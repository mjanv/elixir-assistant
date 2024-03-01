defmodule Assistant.Agent.SwarmTest do
  @moduledoc false

  use ExUnit.Case, async: true

  defmodule SimpleAgent do
    use Assistant.Agent
  end

  defmodule AgentSwarm do
    use Assistant.Agents.Swarm

    agents "group_a" do
      {SimpleAgent, ["a"]}
      {SimpleAgent, ["b"]}
    end
  end

  test "test" do
    result = AgentSwarm.start([])

    assert result == 1
  end
end
