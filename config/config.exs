# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sprinkler,
  ecto_repos: [Sprinkler.Repo]

# Configures the endpoint
config :sprinkler, SprinklerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "waMq4QHBtdZppI5ZKJlhHt4MslX/qCH+1Qs1KSS3jACwndYxcOQ226h5yNcGNnl7",
  render_errors: [view: SprinklerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Sprinkler.PubSub,
  live_view: [signing_salt: "0rRbKVvU"],
  broker_host: "localhost",
  broker_port: 1883

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
