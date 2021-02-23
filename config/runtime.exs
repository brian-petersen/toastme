import Config

require Logger

facebook_client_id = System.get_env("FACEBOOK_CLIENT_ID")
facebook_client_secret = System.get_env("FACEBOOK_CLIENT_SECRET")

if facebook_client_id == nil or facebook_client_secret == nil do
  Logger.warn(
    "FACEBOOK_CLIENT_ID or FACEBOOK_CLIENT_SECRET is not set. Logging in via Facebook may not work"
  )
end

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: facebook_client_id,
  client_secret: facebook_client_secret

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :toastme, ToastMe.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :toastme, ToastMeWeb.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    server: true
end
