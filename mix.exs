defmodule Commissionate.Mixfile do
  use Mix.Project

  def project do
    [
      app: :commissionate,
      version: "0.0.1",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Docs
      name: "Commisionate",
      source_url: "https://github.com/gorkaio/commisionate",
      docs: [
        main: "Commisionate",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      mod: {Commissionate.Application, []},
      extra_applications: [:logger, :runtime_tools, :eventstore, :exconstructor, :timex]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.3"},
      {:postgrex, "== 0.13.5"},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 1.0"},
      {:commanded, "~> 0.17.2"},
      {:commanded_eventstore_adapter, "~> 0.4.0", runtime: Mix.env() != :test},
      {:commanded_ecto_projections, "~> 0.6"},
      {:poison, "~> 3.1"},
      {:uuid, "~> 1.1"},
      {:vex, "~> 0.8.0"},
      {:exconstructor, "~> 1.1"},
      {:timex, "~> 3.4"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 0.9", only: :dev, runtime: false},
      {:ex_machina, "~> 2.0", only: :test}
    ]
  end

  defp aliases do
    [
      "db.setup": ["event_store.setup", "ecto.setup"],
      "db.drop": ["event_store.drop", "ecto.drop"],
      "event_store.setup": ["event_store.create", "event_store.init"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
