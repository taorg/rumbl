# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :rumbl,
  ecto_repos: [Rumbl.Repo]

# Configures the endpoint
config :rumbl, Rumbl.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ahkgkxMx3nvlusx0og68Vshu0JZ4ZlHh2qY2mEQhA0AXFZg83wVCBRqu2HQCRzL0",
  render_errors: [view: Rumbl.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Rumbl.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
# Configures Arc is a flexible file upload library for Elixir
config :arc,
  storage: Arc.Storage.Local  #Arc.Storage.S3 or Arc.Storage.Local
  #,bucket: {:system, "AWS_S3_BUCKET"}, # if using Amazon S3

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
