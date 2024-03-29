defmodule Assistant.Tea do
  @moduledoc false

  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :name, :string
    field :description, :string
    field :start_price, :integer
    field :ingredients, {:array, :string}
  end
end

defmodule Assistant.Tea.Prompts do
  @moduledoc false

  alias Assistant.Models.Chat.ExInstructor

  def describe(query) do
    ExInstructor.response(
      Assistant.Tea,
      "What is the name of this tea whose French webpage is: #{query}"
    )
  end
end

defmodule Assistant.Tea.Embeddings do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query
  import Pgvector.Ecto.Query

  alias Assistant.Repo

  schema "embeddings" do
    embeds_one :tea, Assistant.Schemas.Tea
    field :embedding, Pgvector.Ecto.Vector

    timestamps()
  end

  @doc false
  def changeset(embedding, attrs) do
    embedding
    |> cast(attrs, [:embedding])
    |> validate_required([:embedding])
  end

  def insert(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def neighbors(vector, limit \\ 5) do
    query =
      from i in __MODULE__,
        order_by: l2_distance(i.embedding, ^vector),
        limit: ^limit

    query
    |> Repo.all()
    |> Enum.map(fn item -> %{item | embedding: Pgvector.to_tensor(item.embedding)} end)
  end
end
