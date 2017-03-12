# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :listen,
  ecto_repos: [Listen.Repo]

# Configures the endpoint
config :listen, Listen.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yhA6pUpGc/swyvjq384YBwfy65b7xg3ZDDpz6r8kyKy/UVIiNuX+eTs6ogtOTCQ7",
  render_errors: [view: Listen.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Listen.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Hivent
config :hivent,
  backend: :redis,
  endpoint: System.get_env("HIVENT_URL"),
  partition_count: 4,
  client_id: "listen"

# Configure your database
config :listen, Listen.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  pool_size: 10

# Configure Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "PageturnerIdentity.#{Mix.env}",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: "tMNnxbTs4Ave+n3D9vEO92kBZSpQq/D/njTbeElV+bRdTSMhfnqdOLfTqHKvbkZ1",
  serializer: Listen.Auth.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
