defmodule Assistant.Agents.ChatAssistant do
  @moduledoc false

  use Assistant.Agent

  alias Assistant.Apis.OpenAI

  @impl true
  def init(_args) do
    Logger.info("[#{__MODULE__}] Starting.")
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:chat, text}, state) do
    Phoenix.PubSub.broadcast(Assistant.PubSub, "messages", {:message, text})
    prompt = "You are a kind and helpful assistant. Respond always with one to two sentences."
    response = OpenAI.batch(text, prompt)
    :ok = GenServer.cast(Assistant.Agents.TextToSpeech, {:speak, response})
    Phoenix.PubSub.broadcast(Assistant.PubSub, "messages", {:message, response})
    Logger.info("[#{__MODULE__}] #{text} > #{response}")
    {:noreply, state}
  end
end
