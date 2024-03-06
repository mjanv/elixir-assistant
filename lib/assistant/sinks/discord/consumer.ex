defmodule Assistant.Sinks.Discord.Consumer do
  @moduledoc false

  use Nostrum.Consumer

  require Logger

  @spec handle_event({atom(), any(), any()}) :: :ignore | :ok
  def handle_event({:GUILD_UNAVAILABLE, _payload, _state}), do: :ignore
  def handle_event({:GUILD_AVAILABLE, _payload, _state}), do: :ignore

  def handle_event({:READY, %Nostrum.Struct.Event.Ready{application: application}, _state}) do
    application.id
    |> Nostrum.Api.bulk_overwrite_global_application_commands(commands())
    |> case do
      {:ok, _} -> Logger.info("[#{__MODULE__}] Slash commands created")
      {:error, reason} -> Logger.error("[#{__MODULE__}] #{inspect(reason)}")
    end

    :ok
  end

  def handle_event({:MESSAGE_CREATE, message, _}) do
    Logger.info("[#{__MODULE__}] #{inspect(message)}")
    :ignore
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{data: %{name: name}, channel_id: channel_id} = interaction,
         _}
      ) do
    response = %{type: 4, data: %{content: "response to #{name}:#{channel_id}"}}
    Nostrum.Api.create_interaction_response(interaction, response)
    :ok
  end

  def handle_event({_event, _payload, _state}) do
    :ignore
  end

  @spec publish(any(), atom() | integer()) :: :ok
  def publish(message, channel) do
    GenServer.cast(__MODULE__, {:message, channel(channel), message})
  end

  @impl true
  def handle_cast({:message, channel, message}, state) do
    Nostrum.Api.create_message(channel, message)
    {:noreply, state}
  end

  defp channel(key) when is_integer(key), do: key

  defp channel(key) when is_atom(key) do
    :assistant
    |> Application.get_env(:discord)
    |> Map.get(:channels)
    |> Keyword.get(key)
  end

  defp commands do
    [
      %{
        name: "docs",
        description: "Generate documentation",
        options: [
          %{
            # ApplicationCommandType::STRING
            type: 3,
            name: "project",
            description: "Project name",
            required: true,
            choices: [%{name: "Assistant", value: "assistant"}]
          }
        ]
      }
    ]
  end
end
