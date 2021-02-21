defmodule ToastMeWeb.Authentication do
  alias Plug.Conn

  def signed_in?(conn) do
    not is_nil(Conn.get_session(conn, :current_user_id))
  end

  def current_user_id(conn) do
    Conn.get_session(conn, :current_user_id)
  end
end
