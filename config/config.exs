# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :enhanced_map,
  ecto_repos: [EnhancedMap.Repo]

# Configures the endpoint
config :enhanced_map, EnhancedMap.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Jyi1KRG2PBbSiqBSQtYGIrVptpcFIBaxoRqPmtcTtIGIEKlU7JYM7bpbjf/z4eTQ",
  render_errors: [view: EnhancedMap.ErrorView, accepts: ~w(html json)],
  pubsub: [name: EnhancedMap.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :addict,
  secret_key: "243262243132244a7238773248354775763072612f766f524955396e65",
  extra_validation: fn ({valid, errors}, user_params) -> {valid, errors} end, # define extra validation here
  user_schema: EnhancedMap.User,
  repo: EnhancedMap.Repo,
  from_email: "tom.freudenheim@me.com",
  mailgun_domain: "https://api.mailgun.net/v3/sandboxc603905cad7746479a67d9feb600aba4.mailgun.org",
  mailgun_key: "key-ab71e9c4eb66e1da296b1baf356ebffd",
  mail_service: :mailgun,
  generate_csrf_token: (fn -> Phoenix.Controller.get_csrf_token end)
