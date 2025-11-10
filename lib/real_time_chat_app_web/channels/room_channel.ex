defmodule RealTimeChatAppWeb.RoomChannel do
  @moduledoc """
  Handles real-time communication for the chat room via WebSockets.

  This channel manages:
  - User joins/leaves (via Presence)
  - Real-time message broadcasting
  - Typing indicators

  Think of this as the "telephone operator" that routes messages
  between all connected users in the lobby.
  """
  use Phoenix.Channel

  alias RealTimeChatApp.Chat
  alias RealTimeChatApp.Accounts

  # When a user joins the lobby, we fetch their info and set up presence tracking
  # The :after_join message ensures we track presence after the join is confirmed
  def join("room:lobby", _payload, socket) do
    # Grab the user from the database - we stored their ID in the socket during connection
    user = Accounts.get_user!(socket.assigns.user_id)

    # Send ourselves a message to handle presence tracking after join completes
    # This is a common pattern to avoid race conditions
    send(self(), :after_join)

    {:ok, assign(socket, :user, user)}
  end

  # Once we've successfully joined, let everyone know we're here!
  # Presence keeps track of who's online without storing state in the database
  def handle_info(:after_join, socket) do
    RealTimeChatAppWeb.Presence.track(
      self(),
      "room:lobby",
      socket.assigns.user.id,
      %{
        username: socket.assigns.user.username,
        avatar_color: socket.assigns.user.avatar_color,
        online_at: DateTime.utc_now() |> DateTime.to_iso8601()
      }
    )

    {:noreply, socket}
  end

  # Handle incoming messages from clients
  # We save to the database first (for persistence), then broadcast to everyone
  def handle_in("new_message", %{"content" => content}, socket) do
    case Chat.create_message(%{
           content: content,
           user_id: socket.assigns.user.id
         }) do
      {:ok, message} ->
        # Reload to get the full user association (we need username, avatar, etc.)
        message = Chat.get_message!(message.id)

        # Broadcast to all other channel subscribers (WebSocket clients)
        # broadcast_from means "send to everyone except the sender"
        broadcast_from(socket, "new_message", %{
          id: message.id,
          content: message.content,
          user: %{
            id: message.user.id,
            username: message.user.username,
            avatar_color: message.user.avatar_color
          },
          inserted_at: message.inserted_at |> DateTime.to_iso8601()
        })

        # Also broadcast via PubSub for LiveView clients
        # This allows both WebSocket channels AND LiveView to receive updates
        # PubSub is Phoenix's pub/sub system - think of it as a radio station
        Phoenix.PubSub.broadcast(
          RealTimeChatApp.PubSub,
          "room:lobby",
          {:new_message, %{
            id: message.id,
            content: message.content,
            user: %{
              id: message.user.id,
              username: message.user.username,
              avatar_color: message.user.avatar_color
            },
            user_id: message.user.id,
            inserted_at: message.inserted_at |> DateTime.to_iso8601()
          }}
        )

        {:noreply, socket}

      {:error, _changeset} ->
        # Something went wrong - maybe invalid content or database issue
        {:reply, {:error, %{reason: "invalid message"}}, socket}
    end
  end

  # Typing indicators - let others know when someone is typing
  # This makes the chat feel more "live" and responsive
  def handle_in("typing", %{"typing" => typing}, socket) do
    # Broadcast to channel subscribers (WebSocket clients)
    broadcast_from(socket, "user_typing", %{
      user_id: socket.assigns.user.id,
      username: socket.assigns.user.username,
      typing: typing
    })

    # Also broadcast via PubSub for LiveView clients
    Phoenix.PubSub.broadcast(
      RealTimeChatApp.PubSub,
      "room:lobby",
      {:user_typing, %{
        user_id: socket.assigns.user.id,
        username: socket.assigns.user.username,
        typing: typing
      }}
    )

    {:noreply, socket}
  end
end
