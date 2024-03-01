defmodule Assistant.Agent do
  @moduledoc false

  defmacro __using__(opts) do
    timeout = Keyword.get(opts, :timeout, :infinity)

    quote do
      use GenServer

      require Logger

      @timeout unquote(timeout)

      def start_link(args) do
        GenServer.start_link(__MODULE__, args, name: __MODULE__)
      end

      @impl true
      def init(%{id: id, session: session}) do
        Logger.info("[#{__MODULE__}] Starting.")

        Phoenix.PubSub.subscribe(Assistant.PubSub, "session:#{session}")
        AssistantWeb.Presence.track(self(), "session:#{session}", id, %{})

        agent = %{id: id, session: session, state: %{}}

        {:ok, agent, @timeout}
      end

      @impl true
      def handle_info(:timeout, agent) do
        {:stop, :normal, agent}
      end

      @impl true
      def handle_info(%{event: "presence_diff"}, agent) do
        {:noreply, agent, @timeout}
      end

      @impl true
      def handle_info(event, %{session: session, state: state} = agent) do
        state
        |> handle(event)
        |> tap(fn {_, events} ->
          Enum.each(events, fn event ->
            Phoenix.PubSub.broadcast_from(Assistant.PubSub, self(), "session:" <> session, event)
          end)
        end)
        |> then(fn {state, _} -> {:noreply, %{agent | state: state}, @timeout} end)
      end

      def handle(state, _event), do: {state, []}
      defoverridable handle: 2
    end
  end
end
