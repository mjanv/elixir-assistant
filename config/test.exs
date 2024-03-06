import Config

config :assistant, Assistant.Repo,
  database: Path.expand("../data/assistant_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

config :assistant, AssistantWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "e/Kwma82h1DsmkmY6hmTf6adtNgIBH1Q1RiMupQbxOw7ZQmnptqT/Nwfi1s/Sb62",
  server: false

config :libcluster,
  topologies: []

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
