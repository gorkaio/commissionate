use Mix.Config

config :commissionate,
  ecto_repos: [Commissionate.Repo]

config :commissionate, CommissionateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EEP+obV8anMWe4bzhbEnteNljDUE2Ie5Qerm7bPxq8S0Feb9i6m9Xwd5H35tp6TT",
  render_errors: [view: CommissionateWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Commissionate.PubSub, adapter: Phoenix.PubSub.PG2]

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: Commissionate.Repo

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :vex,
  sources: [
    Commissionate.Support.Validators,
    Commissionate.Merchants.Validators,
    Commissionate.Shoppers.Validators,
    Vex.Validators
  ]

import_config "#{Mix.env()}.exs"
