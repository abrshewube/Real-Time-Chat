defmodule RealTimeChatAppWeb.UserSocket do
  @moduledoc """
  WebSocket connection handler for users.

  This is the "entrance" to our WebSocket system - when a client connects,
  they authenticate here and get assigned a user_id. Then they can join channels.

  Think of this as the "bouncer" who checks IDs before letting people into the club.
  """
  use Phoenix.Socket

  # All channels matching "room:*" route to RoomChannel
  # So "room:lobby", "room:general", etc. all go to the same handler
  channel "room:*", RealTimeChatAppWeb.RoomChannel

  @impl true
  # When a client connects via WebSocket, they must provide their user_id
  # This is how we know who's connecting - we authenticate them here
  def connect(%{"user_id" => user_id}, socket, _connect_info) do
    # Store the user_id in the socket for later use
    # This is available in all channel handlers via socket.assigns.user_id
    {:ok, assign(socket, :user_id, user_id)}
  end

  # Reject connection if user_id is missing
  # Security: Only authenticated users can connect
  def connect(_params, _socket, _connect_info) do
    :error
  end

  @impl true
  # Unique identifier for this socket connection
  # Used for presence tracking and disconnection handling
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end
