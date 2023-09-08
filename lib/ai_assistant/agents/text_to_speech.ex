defmodule AiAssistant.Agents.TextToSpeech do
  @moduledoc false

  use AiAssistant.Agent

  alias AiAssistant.Apis.ElevenLabs

  @impl true
  def init(_args) do
    Logger.info("[#{__MODULE__}] Starting.")
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:speak, text}, state) do
    speech = ElevenLabs.generate(text)
    path = "test1.mp3"
    File.write!(path, speech)
    :ok = GenServer.cast(Assistant.Agents.SpeechToSpeaker, {:talk, path})
    {:noreply, state}
  end
end
