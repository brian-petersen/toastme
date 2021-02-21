defmodule ToastMeWeb.PagesController do
  use ToastMeWeb, :controller

  alias ToastMe.Profiles
  alias ToastMeWeb.Authentication

  def home(conn, _params) do
    signed_in? = Authentication.signed_in?(conn)

    cond do
      signed_in? and has_setup_profile?(conn) ->
        redirect(conn, to: Routes.match_path(conn, :index))

      signed_in? ->
        redirect(conn, to: Routes.setup_path(conn, :index))

      true ->
        render(conn, "home.html")
    end
  end

  defp has_setup_profile?(conn) do
    profile =
      conn
      |> Authentication.current_user_id()
      |> Profiles.get_for_user()

    profile != nil
  end
end
