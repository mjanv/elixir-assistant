defmodule Assistant.Apis.Ollama.OllamaServer do
  @moduledoc false

  use GenServer

  require Logger

  @url Application.compile_env(:instructor, :openai)[:api_url]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    :timer.send_interval(1_000, self(), :check)
    {:ok, %{}}
  end

  def handle_info(:check, state) do
    server_running?(@url)
    {:noreply, state}
  end

  def server_running?(url) do
    [base_url: url]
    |> Req.new()
    |> Req.get(url: "/api", retry: false)
    |> case do
      {:ok, %Req.Response{status: 200}} ->
        Logger.info("Ollama server is running")
        true

      {:error, error} ->
        Logger.error("Ollama server is not running #{inspect(error)}")
        false
    end
  end

  def start do
    Logger.info("Starting Ollama server")
    System.cmd(~c"ollama serve", [])
  end
end
