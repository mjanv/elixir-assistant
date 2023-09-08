defmodule AiAssistant.Agents.WakeWord do
  @moduledoc false

  use AiAssistant.Agent

  alias AiAssistant.Models.Picovoice

  @wait 5_000

  @impl true
  def init(_args) do
    Logger.info("[#{__MODULE__}] Starting.")
    Process.send_after(self(), :listen, 100)
    config = Application.fetch_env!(:ai_assistant, :picovoice)
    {:ok, %{config: config}}
  end

  @impl true
  def handle_info(:listen, %{config: config} = state) do
    Logger.info("[#{__MODULE__}] Listening.")
    path = Picovoice.query(config[:access_token], config[:keyword_path], config[:model_path])
    :ok = GenServer.cast(Assistant.Agents.SpeechToText, {:transcribe, path})

    Phoenix.PubSub.broadcast(AiAssistant.PubSub, "messages", {:message, "Wake word!"})

    Process.send_after(self(), :listen, @wait)
    {:noreply, state}
  end
end
