import Config

config :ai_assistant,
  pipeline: []

config :ai_assistant, AiAssistant.Repo,
  database: Path.expand("../ai_assistant_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

config :ai_assistant, AiAssistantWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "e/Kwma82h1DsmkmY6hmTf6adtNgIBH1Q1RiMupQbxOw7ZQmnptqT/Nwfi1s/Sb62",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
