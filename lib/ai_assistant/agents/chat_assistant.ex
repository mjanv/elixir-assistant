defmodule AiAssistant.Agents.ChatAssistant do
  @moduledoc false

  use AiAssistant.Agent

  alias Assistant.Apis.OpenAI

  @impl true
  def init(_args) do
    Logger.info("[#{__MODULE__}] Starting.")
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:chat, text}, state) do
    response = OpenAI.chat(text)
    :ok = GenServer.cast(Assistant.Agents.TextToSpeech, {:speak, response})
    Logger.info("[#{__MODULE__}] #{text} > #{response}")
    {:noreply, state}
  end
end
