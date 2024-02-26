defmodule AssistantWeb.DashboardLive.Index do
  @moduledoc false

  use AssistantWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Assistant.PubSub, "messages")
    end

    {:ok, stream(socket, :messages, [])}
  end

  @impl true
  def handle_info({:message, message}, socket) do
    {:noreply,
     stream_insert(socket, :messages, %{id: :rand.uniform(1_000_000), text: message}, at: 0)}
  end
end
