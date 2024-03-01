defmodule AssistantWeb.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      AssistantWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:assistant, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Assistant.PubSub},
      AssistantWeb.Presence,
      AssistantWeb.Endpoint
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
