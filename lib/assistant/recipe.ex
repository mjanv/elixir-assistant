defmodule Assistant.Recipe do
  @moduledoc false

  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :title, :string
    field :cook_time, :integer
    field :steps, {:array, :string}

    embeds_many :ingredients, Ingredients, primary_key: false do
      field :name, :string
      field :quantity, :decimal
      field :unit, :string
    end
  end

  def ask(query) do
    Instructor.chat_completion(
      mode: :json,
      model: "gpt-3.5-turbo",
      response_model: __MODULE__,
      messages: [%{role: "user", content: query}]
    )
  end

  def ask_stream(query, dest) do
    Instructor.chat_completion(
      mode: :json,
      model: "gpt-3.5-turbo",
      response_model: {:partial, __MODULE__},
      stream: true,
      messages: [%{role: "user", content: query}]
    )
    |> Stream.each(&send(dest, &1))
    |> Stream.run()
  end
end
