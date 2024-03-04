import Config

config :assistant, Assistant.Repo,
  username: "postgres",
  password: "postgres",
  database: "assistant_dev",
  hostname: "localhost",
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :assistant, AssistantWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "IbINSUAbtpgsXdb+IrnqdRmP8GQoRVvgzJDTf23NDTZk0Vorng8Chs6LhSqguU+Y",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

config :assistant, AssistantWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/assistant_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :assistant, dev_routes: true

config :libcluster,
  topologies: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :wallaby,
  driver: Wallaby.Chrome,
  base_url: "https://jardin-du-the.com"

config :wallaby, :geckodriver, path: "./geckodriver"
