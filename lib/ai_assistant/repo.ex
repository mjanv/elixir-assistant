defmodule AiAssistant.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :ai_assistant,
    adapter: Ecto.Adapters.SQLite3
end
