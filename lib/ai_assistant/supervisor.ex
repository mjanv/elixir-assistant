defmodule AiAssistant.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      # AiAssistant.Repo,
      # AiAssistant.Agents.TwitchChat,
      AiAssistant.Agents.WakeWord,
      {AiAssistant.Agents.SpeechToText, model: "tiny"}
      # AiAssistant.Agents.ChatAssistant,
      # AiAssistant.Agents.TextToSpeech,
      # AiAssistant.Agents.SpeechToSpeaker
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
