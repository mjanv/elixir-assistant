defmodule Assistant.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :assistant,
    adapter: Ecto.Adapters.Postgres
end
