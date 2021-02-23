defmodule ToastMeWeb.SetupLive do
  use ToastMeWeb, :live_view

  alias ToastMe.Profiles

  require Logger

  # TODO allow editing existing profile
  @impl true
  def mount(_params, session, socket) do
    %{"current_user_id" => user_id} = session

    {:ok,
     socket
     |> assign(:hide_profile_dependent_menu, true)
     |> assign(:user_id, user_id)
     |> assign(:bio, "")
     |> allow_upload(:photos,
       accept: ~w(.jpg .jpeg .png),
       max_file_size: 5 * 1_024 * 1_024,
       max_entries: 5
     )}
  end

  @impl true
  def handle_event("remove-photo", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  @impl true
  def handle_event("change", %{"bio" => bio}, socket) do
    {:noreply, assign(socket, :bio, bio)}
  end

  @impl true
  def handle_event("submit", _params, socket) do
    params = %{
      user_id: socket.assigns.user_id,
      bio: socket.assigns.bio,
      photos: get_photo_filenames(socket)
    }

    case Profiles.create(params) do
      {:ok, profile} ->
        copy_uploaded_files(socket, profile)
        {:noreply, redirect(socket, to: Routes.match_path(socket, :index))}

      {:error, changeset} ->
        # TODO show changeset errors
        IO.inspect(changeset)
        {:noreply, socket}
    end
  end

  defp copy_uploaded_files(socket, profile) do
    consume_uploaded_entries(socket, :photos, fn meta, entry ->
      filename = get_photo_entry_filename(entry)
      dest = Path.join([Application.app_dir(:toastme), "priv/static/uploads", filename])

      case File.cp(meta.path, dest) do
        {:error, reason} ->
          # TODO mark profile as dirty?
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

  defp get_photo_entry_filename(entry) do
    "#{entry.uuid}.#{ext(entry.client_type)}"
  end

  defp get_photo_filenames(socket) do
    {photo_entries, []} = uploaded_entries(socket, :photos)
    Enum.map(photo_entries, &get_photo_entry_filename/1)
  end
end
