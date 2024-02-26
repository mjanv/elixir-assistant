defmodule Assistant.Projection do
  @moduledoc false

  use Ecto.Schema

  require Logger

  @primary_key false
  embedded_schema do
    field :title, :string
    field :showtime, {:array, :time}
  end

  def find(query) do
    Instructor.chat_completion(
      mode: :json,
      stream: true,
      model: "gpt-3.5-turbo",
      response_model: {:array, __MODULE__},
      messages: [
        %{
          role: "user",
          content: "Find all the projections included in the following french text: #{query}"
        }
      ]
    )
    |> Stream.map(fn result -> Logger.info(result) end)
    |> Stream.run()
  end
end
