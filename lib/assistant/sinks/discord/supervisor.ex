defmodule Assistant.Sinks.Discord.Supervisor do
  @moduledoc false

  use Supervisor

  alias Assistant.Sinks.Discord.{Consumer, Producer}

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {Consumer, name: Discord.Consumer}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
