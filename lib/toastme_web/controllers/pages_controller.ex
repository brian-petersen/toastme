defmodule ToastMeWeb.PagesController do
  use ToastMeWeb, :controller

  alias ToastMeWeb.Authentication

  def home(conn, _params) do
    if Authentication.signed_in?(conn) do
      redirect(conn, to: Routes.setup_path(conn, :index))
    else
      render(conn, "home.html")
    end
  end
end
