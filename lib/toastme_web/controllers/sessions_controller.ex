defmodule ToastMeWeb.SessionsController do
  use ToastMeWeb, :controller

  alias ToastMeWeb.Tokens

  def create(conn, %{"token" => token}) do
    case Tokens.verify(token) do
      {:ok, user_id} ->
        conn
        |> put_session(:current_user_id, user_id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.home_path(conn, :index))

      _ ->
        send_resp(conn, 400, "Not cool")
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: Routes.home_path(conn, :index))
  end
end
