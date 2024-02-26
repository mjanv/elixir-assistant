defmodule Assistant.Agents.SpeechToSpeaker do
  @moduledoc false

  use Assistant.Agent

  alias Assistant.Audio.Mp3Player

  @impl true
  def init(_args) do
    Logger.info("[#{__MODULE__}] Starting.")
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:talk, path}, state) do
    Mp3Player.play(path)
    File.rm(path)
    {:noreply, state}
  end
end
