defmodule AiAssistant.Agents.ChatAssistant do
  @moduledoc false

  use AiAssistant.Agent

  alias AiAssistant.Apis.OpenAI

  @impl true
  def init(_args) do
    Logger.info("[#{__MODULE__}] Starting.")
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:chat, text}, state) do
    Phoenix.PubSub.broadcast(AiAssistant.PubSub, "messages", {:message, text})
    prompt = "You are a kind and helpful assistant. Respond always with one to two sentences."
    response = OpenAI.batch(text, prompt)
    :ok = GenServer.cast(AiAssistant.Agents.TextToSpeech, {:speak, response})
    Phoenix.PubSub.broadcast(AiAssistant.PubSub, "messages", {:message, response})
    Logger.info("[#{__MODULE__}] #{text} > #{response}")
    {:noreply, state}
  end
end
