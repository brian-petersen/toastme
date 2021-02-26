defmodule ToastMeWeb.AuthenticatePlug do
  alias ToastMeWeb.Authentication
  alias ToastMeWeb.Router.Helpers

  import Phoenix.Controller
  import Plug.Conn

  def init(default) do
    default
  end

  def call(conn, _default) do
    if Authentication.signed_in?(conn) do
      conn
    else
      conn
      |> redirect(to: Helpers.home_path(conn, :index))
      |> halt()
    end
  end
end
