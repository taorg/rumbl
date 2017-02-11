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
  version_timeout: 150_000, # milliseconds
  storage: Arc.Storage.S3,  #Arc.Storage.S3 or Arc.Storage.Local  
  bucket: "phantaweb"
  

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  s3: [
  scheme: "https://",
  host: "s3-eu-west-1.amazonaws.com",
  region: "eu-west-1"
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
