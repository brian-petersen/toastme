defmodule ToastMeWeb.Tokens do
  alias Phoenix.Token
  alias ToastMeWeb.Endpoint

  @salt "jq4EIoul"
  @max_age_in_seconds 60

  def sign(user_id) do
    Token.sign(Endpoint, @salt, user_id)
  end

  def verify(token) do
    Token.verify(Endpoint, @salt, token, max_age: @max_age_in_seconds)
  end
end
