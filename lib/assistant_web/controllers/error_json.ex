defmodule AssistantWeb.ErrorJSON do
  @moduledoc false

  def render(template, _assigns) do
    template
    |> Phoenix.Controller.status_message_from_template()
    |> then(fn message -> %{errors: %{detail: message}} end)
  end
end
