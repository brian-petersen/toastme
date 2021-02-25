defmodule ToastMeWeb.SessionsController do
  use ToastMeWeb, :controller

  alias ToastMe.Profiles
  alias ToastMeWeb.Tokens

  def create(conn, %{"token" => token}) do
    case Tokens.verify(token) do
      {:ok, user_id} ->
        conn
        |> put_session(:current_user_id, user_id)
        |> configure_session(renew: true)
        |> redirect_on_create(user_id)

      _ ->
        send_resp(conn, 400, "Not cool")
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

  defp redirect_on_create(conn, user_id) do
    cond do
      has_setup_profile?(user_id) ->
        redirect(conn, to: Routes.match_path(conn, :index))

      true ->
        redirect(conn, to: Routes.setup_path(conn, :index))
    end
  end
end
