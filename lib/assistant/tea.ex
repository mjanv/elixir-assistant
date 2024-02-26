defmodule Assistant.Tea do
  @moduledoc false

  use Ecto.Schema

  alias Assistant.Models.Chat

  @primary_key false
  embedded_schema do
    field :name, :string
    field :description, :string
    field :start_price, :integer
    field :ingredients, {:array, :string}
  end

  def describe(query) do
    __MODULE__
    |> Chat.response("Describe this tea whose French webpage is: #{query}")
  end
end
