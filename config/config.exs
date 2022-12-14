import Config

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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
