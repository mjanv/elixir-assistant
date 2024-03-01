defmodule Assistant.Agents.DynamicSupervisor do
  @moduledoc false

  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start(agent, _opts \\ []) do
    DynamicSupervisor.start_child(__MODULE__, agent)
  end
end
