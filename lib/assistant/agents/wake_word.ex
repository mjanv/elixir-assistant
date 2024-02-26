defmodule Assistant.Agents.WakeWord do
  @moduledoc false

  use Assistant.Agent

  alias Assistant.Models.Picovoice

  @wait 5_000

  @impl true
  def init(_args) do
    Logger.info("[#{__MODULE__}] Starting.")
    Process.send_after(self(), :listen, 100)
    config = Application.fetch_env!(:assistant, :picovoice)
    {:ok, %{config: config}}
  end

  @impl true
  def handle_info(:listen, %{config: config} = state) do
    Logger.info("[#{__MODULE__}] Listening.")
    Picovoice.detect(config[:access_token], config[:keyword_path], config[:model_path])
    Phoenix.PubSub.broadcast(Assistant.PubSub, "messages", {:message, "Oui ?"})
    path = Picovoice.register(config[:access_token], config[:keyword_path], config[:model_path])
    :ok = GenServer.cast(Assistant.Agents.SpeechToText, {:transcribe, path})

    Process.send_after(self(), :listen, @wait)
    {:noreply, state}
  end
end
