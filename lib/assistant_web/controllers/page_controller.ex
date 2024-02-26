defmodule AssistantWeb.PageController do
  @moduledoc false

  use AssistantWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
