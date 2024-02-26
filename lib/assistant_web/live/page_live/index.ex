defmodule AssistantWeb.PageLive.Index do
  @moduledoc false

  use AssistantWeb, :live_view

  alias Assistant.Recipe
  alias Phoenix.LiveView.AsyncResult

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(form: to_form(%{"query" => nil, "stream" => "false"}))
    |> assign(:recipe, AsyncResult.loading())
    |> then(fn socket -> {:ok, socket} end)
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"query" => query, "stream" => "true"}, socket) do
    dest = self()

    socket
    |> start_async(:recipe, fn -> Recipe.ask_stream(query, dest) end)
    |> then(fn socket -> {:noreply, socket} end)
  end

  @impl true
  def handle_event("save", %{"query" => query, "stream" => "false"}, socket) do
    socket
    |> put_flash(:info, "Recipe generation started")
    |> start_async(:recipe, fn -> Recipe.ask(query) end)
    |> then(fn socket -> {:noreply, socket} end)
  end

  @impl true
  def handle_info({status, %Recipe{} = recipe}, socket)
      when status in [:partial, :ok] do
    socket
    |> assign(:recipe, AsyncResult.ok(%AsyncResult{}, recipe))
    |> then(fn socket -> {:noreply, socket} end)
  end

  @impl true
  def handle_info({_, :stream_next}, socket) do
    socket = put_flash(socket, :error, "Stream next")
    {:noreply, socket}
  end

  @impl true
  def handle_async(:recipe, {:ok, :ok}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_async(:recipe, {:ok, result}, socket) do
    case result do
      {:ok, %Recipe{} = recipe} ->
        socket
        |> put_flash(:info, "Recipe generated successfully")
        |> assign(:recipe, AsyncResult.ok(%AsyncResult{}, recipe))

      {:error, error} ->
        put_flash(socket, :error, "Failed to generate recipe due to #{inspect(error)}")
    end
    |> then(fn socket -> {:noreply, socket} end)
  end

  def handle_async(task, {:exit, reason}, socket) do
    socket
    |> put_flash(:error, "Task #{task} failed: #{inspect(reason)}")
    |> then(fn socket -> {:noreply, socket} end)
  end
end
