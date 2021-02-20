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
