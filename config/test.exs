use Mix.Config

config :commissionate, CommissionateWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :commissionate, Commissionate.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "commissionate_readstore_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "commisionate_eventstore_test",
  hostname: "localhost",
  pool_size: 10  