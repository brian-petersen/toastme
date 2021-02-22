defmodule ToastMeWeb.RoastLive do
  use ToastMeWeb, :live_view

  alias ToastMe.Profile
  alias ToastMe.Matches
  alias ToastMeWeb.ProfileComponent

  require Logger

  @impl true
  def mount(_params, %{"profile" => profile}, socket) do
    matches = load_matches(profile)

    {:ok,
     socket
     |> assign(:matches, matches)
     |> assign(:selected_match_id, nil)
     |> assign(:show_profile, false)}
  end

  @impl true
  def handle_event("set-match", %{"match_id" => match_id}, socket) do
    match_id = String.to_integer(match_id)

    {:noreply,
     socket
     |> assign(:selected_match_id, match_id)
     |> assign(:show_profile, true)}
  end

  @impl true
  def handle_event("close-profile", _params, socket) do
    {:noreply, assign(socket, :show_profile, false)}
  end

  defp load_matches(profile) do
    profile
    |> Matches.get_matches_for_profile()
    |> Enum.into(%{}, fn match ->
      {match.id, match}
    end)
  end

  defp profile_picture(%Profile{photos: [photo | _]}) do
    Profile.resolve_photo(photo)
  end
end
