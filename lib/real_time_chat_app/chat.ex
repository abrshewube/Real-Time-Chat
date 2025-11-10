defmodule RealTimeChatApp.Chat do
  @moduledoc """
  The Chat context handles messaging functionality.

  This is our "chat service" - all message-related operations go through here.
  Keeps chat logic separate from the web layer.
  """

  import Ecto.Query, warn: false
  alias RealTimeChatApp.Repo
  alias RealTimeChatApp.Chat.Message

  # Get the most recent messages (for chat history)
  # We fetch newest first, then reverse to show oldest at top
  def list_messages(limit \\ 50) do
    Repo.all(
      from m in Message,
        order_by: [desc: m.inserted_at],  # Get newest first
        limit: ^limit,
        preload: [:user]  # Load the user association (we need username, avatar, etc.)
    )
    |> Enum.reverse()  # Reverse so oldest appears first (like a real chat)
  end

  # Create a new message
  # Returns {:ok, message} on success, {:error, changeset} on failure
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  # Get a single message by ID, with user preloaded
  # Raises if not found (hence the !)
  def get_message!(id), do: Repo.get!(Message, id) |> Repo.preload(:user)
end
