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
      {Ecto.Migrator,
       repos: Application.fetch_env!(:assistant, :ecto_repos),
       skip: System.get_env("RELEASE_NAME") != nil}
    ]

    pipeline = Application.fetch_env!(:assistant, :pipeline)

    Supervisor.init(children ++ pipeline, strategy: :one_for_one)
  end
end
