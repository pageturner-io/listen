use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :listen, Listen.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :listen, Listen.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  pool: Ecto.Adapters.SQL.Sandbox

# Configure Hivent
config :listen, :hivent, Hivent.Memory

# Configure Guardian
config :guardian, Guardian,
  secret_key: {Listen.Auth.Guardian.SecretKey, :fetch}
