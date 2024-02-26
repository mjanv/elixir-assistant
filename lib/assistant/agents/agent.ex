defmodule Assistant.Agent do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use GenServer

      require Logger

      def start_link(args) do
        GenServer.start_link(__MODULE__, args, name: __MODULE__)
      end
    end
  end
end
