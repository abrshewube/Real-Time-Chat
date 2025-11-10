defmodule RealTimeChatAppWeb.ChatLive do
  use RealTimeChatAppWeb, :live_view

  alias RealTimeChatApp.Chat
  alias RealTimeChatAppWeb.Presence

  on_mount {RealTimeChatAppWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    # Load the last 50 messages from the database
    # We show chat history so users can see what they missed
    messages = Chat.list_messages(50)

    # Only set up subscriptions when the socket is actually connected
    # On initial render (before WebSocket connects), connected? is false
    # This prevents errors during server-side rendering
    if connected?(socket) do
      # Subscribe to PubSub for receiving new messages and presence updates
      # Think of PubSub as a radio - we're tuning into the "room:lobby" station
      Phoenix.PubSub.subscribe(RealTimeChatApp.PubSub, "room:lobby")

      # Tell Presence that we're here! This makes us show up in the online users list
      Presence.track(
        self(),
        "room:lobby",
        socket.assigns.current_user.id,
        %{
          username: socket.assigns.current_user.username,
          avatar_color: socket.assigns.current_user.avatar_color,
          online_at: DateTime.utc_now() |> DateTime.to_iso8601()
        }
      )

      # Get the current list of online users
      # Presence returns a map with user IDs as keys and metadata as values
      presences =
        Presence.list("room:lobby")
        |> Enum.map(fn {user_id, %{metas: [meta | _]}} -> {user_id, meta} end)
        |> Enum.into(%{})

      socket =
        socket
        |> assign(:messages, messages)
        |> assign(:presences, presences)
        |> assign(:typing_users, [])  # Keep track of who's typing
        |> assign(:current_message, "")  # Current input field value
        |> assign(:user, socket.assigns.current_user)

      {:ok, socket}
    else
      # Initial render - just show static content, no subscriptions yet
      {:ok, assign(socket, messages: messages, presences: %{}, typing_users: [], current_message: "", user: socket.assigns.current_user)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-screen flex flex-col bg-gradient-to-br from-gray-50 to-gray-100">
      <!-- Header -->
      <header class="bg-white shadow-sm border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div class="flex items-center justify-between">
            <div class="flex items-center space-x-4">
              <h1 class="text-2xl font-bold text-gray-900">💬 ChatRoom</h1>
              <div class="hidden md:flex items-center space-x-2 text-sm text-gray-600">
                <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
                <span><%= map_size(@presences) %> online</span>
              </div>
            </div>

            <div class="flex items-center space-x-4">
              <div class="flex items-center space-x-2">
                <div
                  class="w-10 h-10 rounded-full flex items-center justify-center text-white font-semibold"
                  style={"background-color: " <> @user.avatar_color}
                >
                  <%= String.first(@user.username) |> String.upcase() %>
                </div>
                <span class="font-medium text-gray-800"><%= @user.username %></span>
              </div>
              <button
                phx-click="logout"
                class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg transition duration-200 font-medium"
              >
                Logout
              </button>
            </div>
          </div>
        </div>
      </header>

      <div class="flex-1 flex overflow-hidden">
        <!-- Sidebar with Online Users -->
        <aside class="hidden md:block w-64 bg-white border-r border-gray-200 overflow-y-auto">
          <div class="p-4">
            <h2 class="text-lg font-semibold text-gray-800 mb-4">Online Users</h2>
            <div class="space-y-3">
              <%= for {user_id, %{metas: [meta | _]}} <- @presences do %>
                <div class="flex items-center space-x-3 p-2 rounded-lg hover:bg-gray-50 transition">
                  <div
                    class="w-10 h-10 rounded-full flex items-center justify-center text-white font-semibold flex-shrink-0"
                    style={"background-color: " <> meta.avatar_color}
                  >
                    <%= String.first(meta.username) |> String.upcase() %>
                  </div>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-gray-900 truncate">
                      <%= meta.username %>
                      <%= if user_id == @user.id do %>
                        <span class="text-gray-500">(You)</span>
                      <% end %>
                    </p>
                    <p class="text-xs text-gray-500">Online</p>
                  </div>
                  <div class="w-2 h-2 bg-green-500 rounded-full"></div>
                </div>
              <% end %>
            </div>
          </div>
        </aside>

        <!-- Main Chat Area -->
        <main class="flex-1 flex flex-col overflow-hidden">
          <!-- Messages Container -->
          <div
            id="messages"
            phx-update="append"
            class="flex-1 overflow-y-auto p-6 space-y-4"
          >
            <%= for message <- @messages do %>
              <% justify_class = if message.user_id == @user.id, do: "justify-end", else: "justify-start" %>
              <% class_attr = "flex " <> justify_class %>
              <% message_id = "message-" <> Integer.to_string(message.id) %>
              <div
                id={message_id}
                class={class_attr}
              >
                <% message_box_class = if message.user_id == @user.id, do: "max-w-md lg:max-w-lg px-4 py-3 rounded-2xl shadow-sm bg-blue-600 text-white", else: "max-w-md lg:max-w-lg px-4 py-3 rounded-2xl shadow-sm bg-white text-gray-900" %>
                <div
                  class={message_box_class}
                >
                  <div class="flex items-center space-x-2 mb-1">
                    <div
                      class="w-6 h-6 rounded-full flex items-center justify-center text-xs font-semibold"
                      style={"background-color: " <> message.user.avatar_color}
                    >
                      <%= String.first(message.user.username) |> String.upcase() %>
                    </div>
                    <% username_class = if message.user_id == @user.id, do: "text-xs font-semibold text-blue-100", else: "text-xs font-semibold text-gray-600" %>
                    <span class={username_class}>
                      <%= message.user.username %>
                    </span>
                    <% time_class = if message.user_id == @user.id, do: "text-xs text-blue-200", else: "text-xs text-gray-400" %>
                    <span class={time_class}>
                      <%= format_time(message.inserted_at) %>
                    </span>
                  </div>
                  <% content_class = if message.user_id == @user.id, do: "text-sm text-white", else: "text-sm text-gray-800" %>
                  <p class={content_class}>
                    <%= message.content %>
                  </p>
                </div>
              </div>
            <% end %>
          </div>

          <!-- Typing Indicator -->
          <div :if={length(@typing_users) > 0} class="px-6 py-2">
            <p class="text-sm text-gray-500 italic">
              <%= Enum.join(@typing_users, ", ") %>
              <%= if length(@typing_users) == 1, do: "is", else: "are" %> typing...
            </p>
          </div>

          <!-- Message Input -->
          <div class="bg-white border-t border-gray-200 p-4">
            <form phx-submit="send_message" phx-change="typing" class="flex space-x-4">
              <input
                type="text"
                name="message"
                value={@current_message}
                phx-debounce="300"
                placeholder="Type your message..."
                maxlength="500"
                class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                autocomplete="off"
              />
              <button
                type="submit"
                disabled={@current_message == ""}
                class="px-6 py-3 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed text-white font-semibold rounded-lg transition duration-200 shadow-md hover:shadow-lg"
              >
                Send
              </button>
            </form>
          </div>
        </main>
      </div>
    </div>
    """
  end

  # User clicked logout - redirect to logout endpoint
  @impl true
  def handle_event("logout", _params, socket) do
    {:noreply, redirect(socket, to: "/logout")}
  end

  # User clicked "Send" - save the message and broadcast it
  @impl true
  def handle_event("send_message", %{"message" => content}, socket) do
    # Save to database first (for persistence)
    # This ensures messages survive server restarts
    case Chat.create_message(%{
           content: String.trim(content),
           user_id: socket.assigns.user.id
         }) do
      {:ok, message} ->
        # Reload to get the full user association (username, avatar, etc.)
        message = Chat.get_message!(message.id)

        # Broadcast to everyone subscribed to "room:lobby"
        # This is how real-time updates work - we publish to PubSub
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

        # Update our local message list
        # We prepend the new message and keep only the last 50
        messages = [message | socket.assigns.messages] |> Enum.take(50)

        {:noreply,
         socket
         |> assign(:messages, messages)
         |> assign(:current_message, "")  # Clear the input field
         |> push_event("scroll_to_bottom", %{})}  # Auto-scroll to see new message

      {:error, _changeset} ->
        # Something went wrong - show an error message
        {:noreply, put_flash(socket, :error, "Failed to send message")}
    end
  end

  # User is typing - let others know (with debouncing)
  # This makes the chat feel more interactive and "live"
  def handle_event("typing", %{"message" => content}, socket) do
    # Check if there's actual content (not just spaces)
    typing = String.trim(content) != ""

    # Only broadcast if we're actually connected
    # Prevents errors during initial page load
    if connected?(socket) do
      Phoenix.PubSub.broadcast(
        RealTimeChatApp.PubSub,
        "room:lobby",
        {:user_typing, %{
          user_id: socket.assigns.user.id,
          username: socket.assigns.user.username,
          typing: typing  # true = typing, false = stopped typing
        }}
      )
    end

    {:noreply, assign(socket, current_message: content)}
  end

  # Someone joined or left - update the online users list
  # Presence broadcasts via PubSub on the presence topic
  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff"}, socket) do
    # Refresh the list of online users
    # Presence_diff is sent automatically by Phoenix Presence when users come/go
    presences =
      Presence.list("room:lobby")
      |> Enum.map(fn {user_id, %{metas: [meta | _]}} -> {user_id, meta} end)
      |> Enum.into(%{})

    {:noreply, assign(socket, presences: presences)}
  end

  # We received a new message via PubSub - update the UI
  # This is how LiveView gets real-time updates from other processes
  def handle_info({:new_message, _message}, socket) do
    # Reload all messages from database to ensure consistency
    # This is safer than trying to append - handles edge cases like deletes
    messages = Chat.list_messages(50)

    # Update the UI and scroll to show the new message
    {:noreply,
     socket
     |> assign(messages: messages)
     |> push_event("scroll_to_bottom", %{})}
  end

  # Someone started or stopped typing - update the typing indicator
  # This makes the chat feel more responsive and "alive"
  def handle_info({:user_typing, %{username: username, typing: typing}}, socket) do
    typing_users =
      if typing do
        # Add them to the typing list (but not ourselves - we don't need to see our own typing)
        [username | socket.assigns.typing_users]
        |> Enum.uniq()  # Remove duplicates
        |> Enum.reject(&(&1 == socket.assigns.user.username))  # Don't show ourselves
      else
        # Remove them from the typing list
        List.delete(socket.assigns.typing_users, username)
      end

    {:noreply, assign(socket, typing_users: typing_users)}
  end

  defp format_time(datetime) do
    # Format datetime as "HH:MM AM/PM" in UTC
    # For production, you'd want to use a timezone library like Tzdata
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> Calendar.strftime("%I:%M %p")
  end
end
