defmodule Assistant.Agents.SpeechToText do
  @moduledoc false

  use Assistant.Agent

  alias Assistant.Models.Whisper

  @impl true
  def init(args) do
    Logger.info("[#{__MODULE__}] Starting.")
    {:ok, %{model: args[:model], language: args[:language], serving: nil}, {:continue, :build}}
  end

  @impl true
  def handle_continue(:build, %{model: model, language: language} = state) do
    {:noreply, %{state | serving: Whisper.build(model, language)}}
  end

  @impl true
  def handle_cast({:transcribe, path}, %{serving: serving} = state) do
    text = Whisper.predict(serving, path)
    Logger.info("[#{__MODULE__}] Transcription: #{text}")
    :ok = GenServer.cast(Assistant.Agents.ChatAssistant, {:chat, text})
    # Phoenix.PubSub.broadcast(Assistant.PubSub, "messages", {:message, text})
    File.rm(path)
    {:noreply, state}
  end
end
