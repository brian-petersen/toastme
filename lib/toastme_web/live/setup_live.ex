defmodule ToastMeWeb.SetupLive do
  use ToastMeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, bio: "")}
  end

  @impl true
  def handle_event("change", %{"bio" => bio}, socket) do
    {:noreply, assign(socket, bio: bio)}
  end

  @impl true
  def handle_event("submit", %{"bio" => bio}, socket) do
    if bio == "" do
      {:noreply, put_flash(socket, :error, "Your bio cannot be blank")}
    else
      {:noreply, put_flash(socket, :info, "Submitted!")}
    end
  end
end
