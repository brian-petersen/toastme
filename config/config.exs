# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :toastme,
  namespace: ToastMe,
  ecto_repos: [ToastMe.Repo]

# Configures the endpoint
config :toastme, ToastMeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KWekZid6Guyb8VTPiVqmDWMGwHqNKf8+jQ0tQiipm0HzNe8bnlXr/7virbLkQLAP",
  render_errors: [view: ToastMeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ToastMe.PubSub,
  live_view: [signing_salt: "YgAnh7DA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Other
config :ueberauth, Ueberauth,
  providers: [
    facebook:
      {Ueberauth.Strategy.Facebook,
       [
         default_scope: "public_profile",
         display: "page"
       ]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
