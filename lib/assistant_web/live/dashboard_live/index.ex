defmodule AssistantWeb.DashboardLive.Index do
  @moduledoc false

  use AssistantWeb, :live_view

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Assistant.PubSub, "session:" <> id)

      spawn(fn ->
        :timer.sleep(1000)
        Assistant.Agents.start(Assistant.Agents.ChatAssistant)
      end)
    end

    socket =
      socket
      |> stream(:messages, [])
      |> assign(:form, to_form(%{"query" => ""}))
      |> assign(:id, id)
      |> assign(:agents, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"query" => _query}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"query" => query}, %{assigns: %{id: id}} = socket) do
    Phoenix.PubSub.broadcast(Assistant.PubSub, "session:" <> id, {:chat, query})
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, %{assigns: %{id: id}} = socket) do
    agents = AssistantWeb.Presence.neighbors("session:" <> id)
    {:noreply, assign(socket, agents: agents)}
  end

  @impl true
  def handle_info({_intent, message}, socket) do
    {:noreply,
     stream_insert(socket, :messages, %{id: :rand.uniform(1_000_000), text: message}, at: 0)}
  end
end
