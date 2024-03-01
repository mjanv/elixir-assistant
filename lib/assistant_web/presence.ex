defmodule AssistantWeb.Presence do
  @moduledoc false

  use Phoenix.Presence,
    otp_app: :assistant,
    pubsub_server: Assistant.PubSub

  def neighbors(id) do
    id
    |> __MODULE__.list()
    |> Enum.map(fn {_id, data} -> List.first(data[:metas]) end)
  end
end
