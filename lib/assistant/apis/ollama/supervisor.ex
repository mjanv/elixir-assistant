defmodule Assistant.Apis.Ollama.Supervisor do
  @moduledoc false

  use Supervisor

  alias Assistant.Apis.Ollama.OllamaServer

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    children = [
      {Task, fn -> OllamaServer.start() end},
      OllamaServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
