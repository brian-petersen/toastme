defmodule ToastMeWeb.MatchLive do
  use ToastMeWeb, :live_view

  require Logger

  @impl true
  def mount(_params, session, socket) do
    %{"current_user_id" => user_id} = session

    {:ok, socket |> assign(:user_id, user_id)}
  end
end
