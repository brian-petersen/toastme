defmodule ToastMeWeb.EnsureProfilePlug do
  import Plug.Conn
  import Phoenix.Controller

  alias ToastMe.Profiles
  alias ToastMeWeb.Router.Helpers, as: Routes

  def init(default) do
    default
  end

  def call(conn, _default) do
    user_id = get_session(conn, :current_user_id)

    case Profiles.get_for_user(user_id) do
      nil ->
        conn
        |> redirect(to: Routes.setup_path(conn, :index))
        |> halt()

      profile ->
        put_session(conn, :profile, profile)
    end
  end
end
