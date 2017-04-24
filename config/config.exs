# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :rumbl,
  app_namespace: Rumbl,
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
  max_retries: 0,
  timeout: 600_000,
  version_timeout: 600_000, # milliseconds
  storage: Arc.Storage.S3,  #Arc.Storage.S3 or Arc.Storage.Local
  bucket: "phantaweb"

config :ex_aws,
  debug_requests: true,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  s3: [
  scheme: "https://",
  host: "s3-eu-west-1.amazonaws.com",
  region: "eu-west-1"
  ]

config :ex_aws, :hackney_opts,
        recv_timeout: 3_000_000
config :ex_aws, :retries,
  max_attempts: 0,
  base_backoff_in_ms: 10,
  max_backoff_in_ms: 10_000
#https://www.digitalocean.com/community/tutorials/how-to-secure-your-redis-installation-on-ubuntu-14-04
config :verk, queues: [default: 25, priority: 10],
              workers_manager_timeout: 1200,
              max_retry_count: 10,
              poll_interval: 5000,
              start_job_log_level: :info,
              done_job_log_level: :info,
              fail_job_log_level: :debug,
              node_id: "1",
              redis_url: "redis://127.0.0.1:6379"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :ex_google, api_key: System.get_env("GOOGLE_API_KEY"),
                   output: "json"

config :oauth2, debug: true,
  serializers: %{
    "application/json" => Poison    
  }
import_config "#{Mix.env}.exs"
