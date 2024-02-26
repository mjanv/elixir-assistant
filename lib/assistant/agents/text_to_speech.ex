defmodule Assistant.Agents.TextToSpeech do
  @moduledoc false

  use Assistant.Agent

  alias Assistant.Apis.ElevenLabs

  @impl true
  def init(_args) do
    Logger.info("[#{__MODULE__}] Starting.")
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:speak, text}, state) do
    text
    |> ElevenLabs.generate()
    |> then(fn speech ->
      path = "test1.mp3"
      File.write!(path, speech)
      path
    end)
    |> then(fn path ->
      GenServer.cast(Assistant.Agents.SpeechToSpeaker, {:talk, path})
    end)
    |> then(fn _ -> {:noreply, state} end)
  end
end
