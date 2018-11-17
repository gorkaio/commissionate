# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :commissionate,
  ecto_repos: [Commissionate.Repo]

# Configures the endpoint
config :commissionate, CommissionateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EEP+obV8anMWe4bzhbEnteNljDUE2Ie5Qerm7bPxq8S0Feb9i6m9Xwd5H35tp6TT",
  render_errors: [view: CommissionateWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Commissionate.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
