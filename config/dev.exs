import Config

config :assistant,
  pipeline: [
    # Assistant.Agents.TwitchChat,
    # Assistant.Agents.WakeWord,
    # {Assistant.Agents.SpeechToText, model: "small", language: "fr"},
    # Assistant.Agents.ChatAssistant,
    # Assistant.Agents.TextToSpeech,
    # Assistant.Agents.SpeechToSpeaker
  ]

config :assistant, Assistant.Repo,
  database: Path.expand("../assistant_dev.db", Path.dirname(__ENV__.file)),
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

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
