defmodule Assistant.Agents.Swarm do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import Assistant.Agents.Swarm, only: [agents: 2]
    end
  end

  defmacro agents(group, var \\ quote(do: _), contents) do
    IO.inspect(contents)
    var = Macro.escape(var)
    contents = Macro.escape(contents, unquote: true) |> IO.inspect()

    quote bind_quoted: [group: group, var: var, contents: contents] do
      def start(unquote(var)), do: {unquote(group), unquote(contents)}
    end
  end
end
