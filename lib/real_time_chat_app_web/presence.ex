defmodule RealTimeChatAppWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  Presence is Phoenix's built-in system for tracking who's online.
  It automatically handles:
  - User joins (when they connect)
  - User leaves (when they disconnect)
  - Multiple tabs/devices (same user can appear multiple times)

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.

  Think of this as a "guest list" that updates automatically.
  """
  use Phoenix.Presence,
    otp_app: :real_time_chat_app,
    pubsub_server: RealTimeChatApp.PubSub
end
