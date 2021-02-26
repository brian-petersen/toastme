defmodule ToastMeWeb.HomeController do
  use ToastMeWeb, :controller

  import Phoenix.LiveView.Controller

  alias ToastMe.Profiles
  alias ToastMeWeb.Authentication
  alias ToastMeWeb.HomeLive

  def index(conn, _params) do
    signed_in? = Authentication.signed_in?(conn)
    user_id = Authentication.current_user_id(conn)

    cond do
      signed_in? and has_setup_profile?(user_id) ->
        redirect(conn, to: Routes.match_path(conn, :index))

      signed_in? ->
        redirect(conn, to: Routes.setup_path(conn, :index))

      true ->
        live_render(conn, HomeLive)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Thanks for being a good sport! Hope to see you around.")
    |> clear_session()
    |> redirect(to: Routes.home_path(conn, :index))
  end

  defp has_setup_profile?(user_id) do
    Profiles.get_for_user(user_id) != nil
  end
end
