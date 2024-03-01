defmodule Assistant.Agents do
  @moduledoc false

  alias Assistant.Agents.DynamicSupervisor

  defdelegate start(agent, opts \\ []), to: DynamicSupervisor
end
