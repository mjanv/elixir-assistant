defmodule Assistant.Agents.WakeWord do
  @moduledoc false

  use GenServer

  alias Assistant.Models.Audio.WakeWord

  @wait 5_000

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def handle_info(:listen, %{config: config} = state) do
    WakeWord.detect(config[:access_token], config[:keyword_path], config[:model_path])
    Phoenix.PubSub.broadcast(Assistant.PubSub, "messages", {:message, "Oui ?"})
    path = WakeWord.register(config[:access_token], config[:keyword_path], config[:model_path])
    :ok = GenServer.cast(Assistant.Agents.SpeechToText, {:transcribe, path})

    Process.send_after(self(), :listen, @wait)
    {:noreply, state}
  end
end
