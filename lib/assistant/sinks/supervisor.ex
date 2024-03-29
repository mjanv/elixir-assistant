defmodule Assistant.Sinks.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      # Assistant.Sinks.Audio.WakeWord,
      # Assistant.Sinks.Audio.LocalPlayer,
      Assistant.Sinks.Discord.Supervisor,
      Assistant.Sinks.DynamicSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
