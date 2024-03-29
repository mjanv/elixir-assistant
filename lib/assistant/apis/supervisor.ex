defmodule Assistant.Apis.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      Assistant.Apis.Ollama.Supervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
