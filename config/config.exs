import Config

config :assistant, :picovoice,
  access_token: System.get_env("PICOVOICE_ACCESS_TOKEN"),
  model_path: "./priv/models/picovoice/porcupine_params_fr.pv",
  keyword_path: "./priv/models/picovoice/Renard_fr_linux_v2_2_0.ppn"

config :assistant, :eleven_labs,
  api_url: "https://api.elevenlabs.io/v1",
  api_key: System.get_env("ELEVEN_LABS_API_KEY"),
  voice_id: "LcfcDJNUP1GQjkzn1xUU",
  model_id: "eleven_monolingual_v1"

config :assistant, :openai,
  api_url: "https://api.openai.com/v1",
  api_key: System.get_env("OPENAI_API_KEY"),
  organisation: System.get_env("OPENAI_ORGANISATION")

config :assistant, :twitch,
  auth_url: "https://id.twitch.tv/oauth2/token",
  api_url: "https://api.twitch.tv/helix",
  chat_ws: "wss://irc-ws.chat.twitch.tv:443",
  oauth_token: System.get_env("TWITCH_OAUTH_TOKEN"),
  channel: System.get_env("TWITCH_CHANNEL")

config :assistant,
  ecto_repos: [Assistant.Repo],
  generators: [binary_id: true]

config :assistant, Assistant.Repo, types: Assistant.PostgrexTypes

config :assistant, AssistantWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: AssistantWeb.ErrorHTML, json: AssistantWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Assistant.PubSub,
  live_view: [signing_salt: "CUTlQPsj"]

config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :instructor,
  adapter: Instructor.Adapters.OpenAI,
  openai: [api_key: System.get_env("OPENAI_API_KEY")]

# openai: [
#   api_key: "ollama",
#   api_url: "http://localhost:11434",
#   models: [
#     "mistral:7b-instruct-q6_K"
#   ]
# ]

config :nostrum,
  token: System.get_env("DISCORD_BOT_TOKEN")

config :nx, :default_backend, EXLA.Backend

import_config "#{config_env()}.exs"
