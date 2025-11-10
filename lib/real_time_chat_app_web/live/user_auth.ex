defmodule RealTimeChatAppWeb.UserAuth do
  @moduledoc """
  Handles authentication for LiveView mounts.
  """
  import Phoenix.LiveView
  import Phoenix.Component
  alias RealTimeChatApp.Accounts

  def on_mount(:ensure_authenticated, _params, session, socket) do
    # Check both string and atom keys for session compatibility
    user_id = session["user_id"] || session[:user_id]

    case user_id do
      nil ->
        {:halt, redirect(socket, to: "/")}

      user_id ->
        case Accounts.get_user(user_id) do
          nil ->
            {:halt, redirect(socket, to: "/")}

          user ->
            {:cont, assign(socket, current_user: user)}
        end
    end
  end

  def on_mount(:redirect_if_authenticated, _params, session, socket) do
    # Check both string and atom keys for session compatibility
    user_id = session["user_id"] || session[:user_id]

    case user_id do
      nil ->
        {:cont, socket}

      user_id ->
        case Accounts.get_user(user_id) do
          nil ->
            {:cont, socket}

          _user ->
            {:halt, redirect(socket, to: "/chat")}
        end
    end
  end
end
