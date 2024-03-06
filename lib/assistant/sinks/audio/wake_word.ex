defmodule Assistant.Sinks.Audio.WakeWord do
  @moduledoc false

  use GenServer

  alias Assistant.Models.Audio.WakeWord

  @wait 5_000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    Process.send_after(self(), :listen, 100)
    {:ok, %{config: Application.get_env(:assistant, :picovoice)}}
  end

  @impl true
  def handle_info(:listen, %{config: config} = state) do
    IO.inspect("Listening for wake word")
    path = WakeWord.query(config[:access_token], config[:keyword_path], config[:model_path])
    IO.inspect("Wake word register#{path}")

    Process.send_after(self(), :listen, @wait)
    {:noreply, state}
  end
end
