defmodule Assistant.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AssistantWeb.Supervisor,
      Assistant.Supervisor,
      {Cluster.Supervisor,
       [Application.get_env(:libcluster, :topologies), [name: Assistant.ClusterSupervisor]]}
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: Assistant.Application.Supervisor
    )
  end
end
