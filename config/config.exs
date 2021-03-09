# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :petal,
  ecto_repos: [Petal.Repo]

# Configures the endpoint
config :petal, PetalWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "b1p6PE/WfJFKQBjxOqcZJDZrg7xUBBWlqea15UD5a6NhpS5dHcHTTM3nBV5E9rfm",
  render_errors: [view: PetalWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Petal.PubSub,
  live_view: [signing_salt: "B5qOCrUh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
