defmodule ToastMeWeb.AuthController do
  use ToastMeWeb, :controller

  alias ToastMe.Users

  plug Ueberauth

  def logout(conn, _params) do
    conn
    |> put_flash(:info, "Thanks for being a good sport! Hope to see you around.")
    |> clear_session()
    |> redirect(to: Routes.pages_path(conn, :home))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to login! Please try again.")
    |> redirect(to: Routes.pages_path(conn, :home))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Users.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.pages_path(conn, :home))

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.pages_path(conn, :home))
    end
  end

  if Mix.env() in [:dev, :test] do
    def dangerous(conn, %{"user_id" => user_id}) do
      conn
      |> put_session(:current_user_id, String.to_integer(user_id))
      |> configure_session(renew: true)
      |> redirect(to: Routes.pages_path(conn, :home))
    end
  end
end
