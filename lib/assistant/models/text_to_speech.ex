defmodule Assistant.Models.TextToSpeech do
  @moduledoc false

  use GenServer

  require Logger

  alias Assistant.Apis.ElevenLabs

  def init(_args) do
    Logger.info("[#{__MODULE__}] Starting.")
    {:ok, %{}}
  end

  def speak(text) do
    GenServer.cast(__MODULE__, {:speak, text})
  end

  @@impl
  def handle_cast({:speak, text}, state) do
    text
    |> ElevenLabs.generate()
    |> case do
      {:ok, speech} ->
        random = for _ <- 1..10, into: "", do: <<Enum.random(~c"0123456789abcdef")>>
        path = random <> ".mp3"
        :ok = File.write!(path, speech)
        Process.send_after(self(), {:rm, path}, 60_000)
        {:ok, path}

      {:error, reason} ->
        {:error, reason}
    end
    |> then(fn response -> {:reply, response, state} end)
  end

  @impl true
  def handle_info({:rm, path}, state) do
    :ok = File.rm(path)
    {:noreply, state}
  end
end
