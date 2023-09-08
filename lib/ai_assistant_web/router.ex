defmodule AiAssistantWeb.Router do
  use AiAssistantWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AiAssistantWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", AiAssistantWeb do
    pipe_through :browser

    # get "/", PageController, :home
    live "/", DashboardLive.Index, :index
  end

  if Application.compile_env(:ai_assistant, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AiAssistantWeb.Telemetry
    end
  end
end
