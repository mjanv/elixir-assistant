defmodule Assistant.Repo.Migrations.CreateTeas do
  use Ecto.Migration

  def change do
    create table(:teas) do
      add :tea, :map
      add :embedding, :vector, size: 386
    end

    create index("teas", ["embedding vector_l2_ops"], using: :hnsw)
  end
end
