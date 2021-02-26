defmodule ToastMeWeb.SetupLive do
  use ToastMeWeb, :live_view

  alias Phoenix.Naming
  alias ToastMe.Profile
  alias ToastMe.Profiles
  alias ToastMeWeb.ErrorHelpers

  require Logger

  # TODO allow editing existing profile
  @impl true
  def mount(_params, session, socket) do
    %{"current_user_id" => user_id} = session

    profile = Profiles.get_for_user(user_id)

    bio = if profile, do: profile.bio, else: ""
    uploaded_photos = if profile, do: profile.photos, else: []

    {:ok,
     socket
     |> assign(:hide_profile_dependent_menu, profile == nil)
     |> assign(:creating_profile, profile == nil)
     |> assign(:user_id, user_id)
     |> assign(:bio, bio)
     |> assign(:uploaded_photos, uploaded_photos)
     |> allow_upload(:photos,
       accept: ~w(.jpg .jpeg .png),
       max_file_size: 5 * 1024 * 1024,
       max_entries: 5
     )
     |> assign(:errors, [])}
  end

  @impl true
  def handle_event("remove-uploaded-photo", %{"path" => path}, socket) do
    uploaded_photos = Enum.reject(socket.assigns.uploaded_photos, &(&1 == path))
    {:noreply, assign(socket, :uploaded_photos, uploaded_photos)}
  end

  @impl true
  def handle_event("remove-photo", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  @impl true
  def handle_event("change", %{"bio" => bio}, socket) do
    {:noreply,
     socket
     |> assign(:bio, bio)
     |> assign(:errors, [])}
  end

  @impl true
  def handle_event("submit", _params, socket) do
    params = %{
      user_id: socket.assigns.user_id,
      bio: socket.assigns.bio,
      photos: socket.assigns.uploaded_photos ++ get_photo_filenames(socket)
    }

    socket =
      case Profiles.create_or_update(params) do
        {:ok, profile, action} ->
          copy_uploaded_files(socket, profile)
          submit_success_result(socket, profile, action)

        {:error, changeset} ->
          errors = ErrorHelpers.pretty_errors(changeset.errors)
          assign(socket, :errors, errors)
      end

    {:noreply, socket}
  end

  defp copy_uploaded_files(socket, profile) do
    consume_uploaded_entries(socket, :photos, fn meta, entry ->
      filename = get_photo_entry_filename(entry)
      dest = Path.join([Application.app_dir(:toastme), "priv/static/uploads", filename])

      case File.cp(meta.path, dest) do
        {:error, reason} ->
          Logger.error("Failed to copy uploaded file #{inspect(reason)} for #{inspect(profile)}")

        :ok ->
          nil
      end
    end)
  end

  defp ext(mime) do
    [ext | _] = MIME.extensions(mime)
    ext
  end

  defp format_errors(errors, photo_errors) do
    errors ++ Enum.map(photo_errors, &format_photo_error/1)
  end

  defp format_photo_error({_, :too_many_files}), do: "Too many profile photos"
  defp format_photo_error({_, :too_large}), do: "Photo is too large"
  defp format_photo_error({_, reason}), do: Naming.humanize(reason)

  defp get_photo_entry_filename(entry) do
    "#{entry.uuid}.#{ext(entry.client_type)}"
  end

  defp get_photo_filenames(socket) do
    {photo_entries, []} = uploaded_entries(socket, :photos)
    Enum.map(photo_entries, &get_photo_entry_filename/1)
  end

  defp submit_success_result(socket, _profile, :create) do
    redirect(socket, to: Routes.match_path(socket, :index))
  end

  defp submit_success_result(socket, profile, :update) do
    socket
    |> assign(:bio, profile.bio)
    |> assign(:uploaded_photos, profile.photos)
    |> put_flash(:info, "Updated profile")
  end
end
