defmodule AssistantWeb.TeaLive.Index do
  @moduledoc false

  use AssistantWeb, :live_view

  alias Phoenix.LiveView.AsyncResult

  alias Assistant.{Apis.Web, Tea}

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(form: to_form(%{"query" => nil}))
    |> assign(:tea, AsyncResult.loading())
    |> then(fn socket -> {:ok, socket} end)
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"query" => query}, socket) do
    socket
    |> start_async(:tea, fn ->
      {:ok, text} = Web.HtmlScraper.extract_text(query)
      {:ok, tea} = Tea.Prompts.describe(text)
      tea
    end)
    |> put_flash(:info, "Tea extraction started")
    |> then(fn socket -> {:noreply, socket} end)
  end

  @impl true
  def handle_async(:tea, {:ok, %Tea{} = tea}, %{assigns: assigns} = socket) do
    socket
    |> put_flash(:info, "Tea extracted successfully")
    |> assign(:tea, AsyncResult.ok(assigns.tea, tea))
    |> then(fn socket -> {:noreply, socket} end)
  end

  def handle_async(task, {:exit, reason}, socket) do
    socket
    |> put_flash(:error, "Task #{task} failed: #{inspect(reason)}")
    |> then(fn socket -> {:noreply, socket} end)
  end
end
