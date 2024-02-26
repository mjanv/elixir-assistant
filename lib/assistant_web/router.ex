defmodule AssistantWeb.Router do
  use AssistantWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AssistantWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", AssistantWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/messages", DashboardLive.Index, :index
    live "/page", PageLive.Index, :index
    live "/tea", TeaLive.Index, :index
  end

  if Application.compile_env(:assistant, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AssistantWeb.Telemetry
    end
  end
end
