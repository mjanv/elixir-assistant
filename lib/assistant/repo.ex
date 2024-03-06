defmodule Assistant.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :assistant,
    adapter: Ecto.Adapters.Postgres

  def migrator(skip) do
    {Ecto.Migrator, repos: Application.fetch_env!(:assistant, :ecto_repos), skip: skip}
  end
end
