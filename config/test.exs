use Mix.Config

config :commissionate, CommissionateWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :commissionate, Commissionate.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: "commissionate_readstore_test",
  hostname: System.get_env("POSTGRES_HOST"),
  pool_size: 1

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: "commisionate_eventstore_test",
  hostname: System.get_env("POSTGRES_HOST"),
  pool_size: 1
