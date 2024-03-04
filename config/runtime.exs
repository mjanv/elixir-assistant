import Config

if System.get_env("PHX_SERVER") do
  config :assistant, AssistantWeb.Endpoint, server: true
end

if config_env() == :prod do
  config :assistant, Assistant.Repo,
    username: System.get_env("DB_USERNAME") || raise("DB_USERNAME missing"),
    password: System.get_env("DB_PASSWORD") || raise("DB_PASSWORD missing"),
    database: System.get_env("DB_NAME") || raise("DB_NAME missing"),
    hostname: System.get_env("DB_HOST") || raise("DB_HOST missing"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5")

  config :assistant, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :assistant, AssistantWeb.Endpoint,
    url: [host: System.get_env("PHX_HOST") || "example.com", port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: System.get_env("SECRET_KEY_BASE") || raise("SECRET_KEY_BASE missing")

  config :libcluster,
    topologies: [
      gossip: [
        strategy: Elixir.Cluster.Strategy.Gossip
      ]
    ]
end
