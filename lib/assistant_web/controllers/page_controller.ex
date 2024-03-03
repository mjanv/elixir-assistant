defmodule AssistantWeb.PageController do
  @moduledoc false

  use AssistantWeb, :controller

  def home(conn, _params) do
    links = [
      %{url: ~p"/session/1", label: "Start a new session", icon: "hero-inbox"},
      %{url: ~p"/tea", label: "Scraper", icon: "hero-document-arrow-down"}
    ]

    nodes = [Node.self()] ++ Node.list()

    render(conn, :home, layout: false, links: links, nodes: nodes)
  end
end
