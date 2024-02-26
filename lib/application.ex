defmodule Assistant.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Assistant.Supervisor,
      AssistantWeb.Supervisor
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: Assistant.Application.Supervisor
    )
  end
end
