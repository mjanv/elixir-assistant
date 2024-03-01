defmodule Assistant.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :assistant,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Assistant.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # Web
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:ecto_sqlite3, "~> 0.15"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.19"},
      {:floki, "~> 0.35", only: :test},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:gettext, "~> 0.24"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.7"},
      {:dns_cluster, "~> 0.1"},
      # {:ex_webrtc, "~> 0.1.0"},
      # Backend
      {:req, "~> 0.4"},
      {:websockex, "~> 0.4"},
      {:wallaby, "~> 0.30"},
      {:rustler, "~> 0.31"},
      {:membrane_sdk, "~> 0.1.0"},
      # Machine learning
      {:instructor, "~> 0.0.5"},
      {:bumblebee, "~> 0.5"},
      {:exla, "~> 0.7"},
      {:nx, "~> 0.7"},
      # Monitoring
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      # Developpement tools
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      quality: ["format --check-formatted", "credo --strict"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      start: ["phx.server"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
