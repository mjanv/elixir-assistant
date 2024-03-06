defmodule Assistant.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      Assistant.Repo,
      Assistant.Repo.migrator(System.get_env("RELEASE_NAME") != nil),
      # Assistant.Agents.Supervisor,
      # Assistant.Apis.Supervisor,
      # Assistant.Models.Supervisor,
      Assistant.Sinks.Supervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
