defmodule AssistantWeb.PageController do
  @moduledoc false

  use AssistantWeb, :controller

  def home(conn, _params) do
    links = [
      %{url: ~p"/messages", label: "Messages", icon: "hero-inbox"},
      %{url: ~p"/tea", label: "Scraper", icon: "hero-document-arrow-down"}
    ]

    render(conn, :home, layout: false, links: links)
  end
end
