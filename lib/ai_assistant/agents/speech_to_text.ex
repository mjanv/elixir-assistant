defmodule AiAssistant.Agents.SpeechToText do
  @moduledoc false

  use AiAssistant.Agent

  alias AiAssistant.Models.Whisper

  @impl true
  def init(args) do
    Logger.info("[#{__MODULE__}] Starting.")
    {:ok, %{model: args[:model], serving: nil}, {:continue, :build}}
  end

  @impl true
  def handle_continue(:build, %{model: model} = state) do
    {:noreply, %{state | serving: Whisper.build(model)}}
  end

  @impl true
  def handle_cast({:transcribe, path}, %{serving: serving} = state) do
    text = Whisper.predict(serving, path)
    Logger.info("[#{__MODULE__}] Transcription: #{text}")
    :ok = GenServer.cast(Assistant.Agents.ChatAssistant, {:chat, text})
    Phoenix.PubSub.broadcast(AiAssistant.PubSub, "messages", {:message, text})
    File.rm(path)
    {:noreply, state}
  end
end
