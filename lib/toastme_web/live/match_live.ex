defmodule ToastMeWeb.MatchLive do
  use ToastMeWeb, :live_view

  alias ToastMe.Profiles
  alias ToastMe.Match
  alias ToastMe.Matches
  alias ToastMeWeb.ProfileComponent

  require Logger

  @impl true
  def mount(_params, session, socket) do
    %{"current_user_id" => user_id} = session
    profile = Profiles.get_for_user(user_id)

    {:ok,
     socket
     |> assign(:user_id, user_id)
     |> assign(:profile_id, profile.id)
     |> load_profiles()}
  end

  @impl true
  def handle_event("pass", _params, socket) do
    create_match(socket, Match.action_pass())
    {:noreply, load_profiles(socket)}
  end

  @impl true
  def handle_event("roast", _params, socket) do
    create_match(socket, Match.action_roast())
    {:noreply, load_profiles(socket)}
  end

  defp create_match(socket, action) do
    %{profile_id: profile_id, matching_profile: %{id: matched_profile_id}} = socket.assigns

    Matches.create(%{
      matcher_profile_id: profile_id,
      matched_profile_id: matched_profile_id,
      action: action
    })
  end

  defp do_load_profiles(profile_id, []) do
    profile_id
    |> Profiles.get_potential_profiles_for_profile()
    |> pop()
  end

  defp do_load_profiles(_profile_id, next_profiles) do
    pop(next_profiles)
  end

  defp load_profiles(socket) do
    profile_id = socket.assigns.profile_id
    next_profiles = socket.assigns[:next_profiles] || []

    {matching_profile, new_next_profiles} = do_load_profiles(profile_id, next_profiles)

    socket
    |> assign(:active_photo, 0)
    |> assign(:matching_profile, matching_profile)
    |> assign(:next_profiles, new_next_profiles)
  end

  defp pop([potential_match | potential_matches]) do
    {potential_match, potential_matches}
  end

  defp pop([]) do
    {nil, []}
  end
end
