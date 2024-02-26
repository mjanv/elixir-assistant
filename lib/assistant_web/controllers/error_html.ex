defmodule AssistantWeb.ErrorHTML do
  @moduledoc false

  use AssistantWeb, :html

  embed_templates "error_html/*"

  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
