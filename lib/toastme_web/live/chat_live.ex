defmodule ToastMeWeb.ChatLive do
  use ToastMeWeb, :live_view

  alias ToastMe.Messages
  alias ToastMeWeb.Endpoint

  require Logger

  @new_message "new-message"

  @impl true
  def mount(_params, session, socket) do
    %{
      "profile" => profile,
      "match" => %{
        matched_profile: matched_profile
      }
    } = session

    messages = Messages.get_messages_between_profiles(profile.id, matched_profile.id)
    topic_name = generate_topic_name(profile.id, matched_profile.id)

    Endpoint.subscribe(topic_name)

    {:ok,
     socket
     |> assign(:draft, "")
     |> assign(:topic_name, topic_name)
     |> assign(:profile_id, profile.id)
     |> assign(:matched_profile_id, matched_profile.id)
     |> assign(:messages, messages)}
  end

  @impl true
  def handle_event("change", %{"draft" => draft}, socket) do
    {:noreply, assign(socket, :draft, draft)}
  end

  @impl true
  def handle_event("send", %{"draft" => draft}, socket) do
    {:noreply, send_message(socket, draft)}
  end

  @impl true
  def handle_info(%{event: @new_message, payload: message}, socket) do
    {:noreply, append_message(socket, message)}
  end

  defp append_message(socket, message) do
    messages = socket.assigns.messages
    assign(socket, :messages, messages ++ [message])
  end

  defp generate_topic_name(profile1_id, profile2_id) do
    if profile1_id < profile2_id do
      "chat:#{profile1_id}-#{profile2_id}"
    else
      "chat:#{profile2_id}-#{profile1_id}"
    end
  end

  defp message_class(message, user_profile_id) do
    if message.sender_profile_id == user_profile_id do
      "text-right"
    else
      "text-left"
    end
  end

  defp send_message(socket, "") do
    socket
  end

  defp send_message(socket, draft) do
    params = %{
      sender_profile_id: socket.assigns.profile_id,
      receiver_profile_id: socket.assigns.matched_profile_id,
      message: draft
    }

    case Messages.create(params) do
      {:ok, message} ->
        Endpoint.broadcast(socket.assigns.topic_name, @new_message, message)
        assign(socket, :draft, "")

      error ->
        Logger.error("Failed to send message: #{inspect(error)}")
        socket
    end
  end
end
