defmodule ToastMeWeb.HomeLive do
  use ToastMeWeb, :live_view

  alias ToastMe.Users
  alias ToastMeWeb.ErrorHelpers
  alias ToastMeWeb.Tokens

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:hide_menu, true)
     |> assign(:username, "")
     |> assign(:password, "")
     |> assign(:password_confirmation, "")
     |> assign(:show_login, true)
     |> assign(:errors, [])}
  end

  @impl true
  def handle_event("show-login", _params, socket) do
    {:noreply, set_show_login(socket, true)}
  end

  @impl true
  def handle_event("hide-login", _params, socket) do
    {:noreply, set_show_login(socket, false)}
  end

  @impl true
  def handle_event("login-change", params, socket) do
    %{
      "username" => username,
      "password" => password
    } = params

    {:noreply,
     socket
     |> assign(:username, username)
     |> assign(:password, password)
     |> assign(:errors, [])}
  end

  @impl true
  def handle_event("register-change", params, socket) do
    %{
      "username" => username,
      "password" => password,
      "password_confirmation" => password_confirmation
    } = params

    {:noreply,
     socket
     |> assign(:username, username)
     |> assign(:password, password)
     |> assign(:password_confirmation, password_confirmation)
     |> assign(:errors, [])}
  end

  @impl true
  def handle_event("login", params, socket) do
    %{
      "username" => username,
      "password" => password
    } = params

    socket =
      case Users.login(username, password) do
        {:ok, user} -> login(socket, user.id)
        {:error, reason} -> assign(socket, :errors, [reason])
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("register", params, socket) do
    socket =
      case Users.register(params) do
        {:error, changeset} ->
          errors = ErrorHelpers.pretty_errors(changeset.errors)
          assign(socket, :errors, errors)

        {:ok, user} ->
          login(socket, user.id)
      end

    {:noreply, socket}
  end

  defp login(socket, user_id) do
    token = Tokens.sign(user_id)
    redirect(socket, to: Routes.sessions_path(socket, :create, token))
  end

  defp set_show_login(socket, state) do
    socket
    |> assign(:show_login, state)
    |> assign(:errors, [])
  end
end
