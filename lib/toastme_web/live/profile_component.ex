defmodule ToastMeWeb.ProfileComponent do
  use ToastMeWeb, :live_component

  alias ToastMe.Profile

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:active_photo, 0)}
  end

  @impl true
  def handle_event("prev-photo", _params, socket) do
    {:noreply, change_photo(socket, -1)}
  end

  @impl true
  def handle_event("next-photo", _params, socket) do
    {:noreply, change_photo(socket, 1)}
  end

  defp change_photo(socket, change) do
    %{active_photo: active, profile: %{photos: photos}} = socket.assigns
    new_index = active + change
    assign(socket, :active_photo, Integer.mod(new_index, length(photos)))
  end
end
