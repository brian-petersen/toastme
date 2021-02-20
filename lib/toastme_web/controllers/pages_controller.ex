defmodule ToastMeWeb.PagesController do
  use ToastMeWeb, :controller

  def home(conn, _params) do
    render(conn, "home.html")
  end
end
