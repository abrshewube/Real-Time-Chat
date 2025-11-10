defmodule RealTimeChatAppWeb.Auth do
  @moduledoc """
  Authentication helpers for the web layer.
  """

  import Plug.Conn
  import Phoenix.Controller

  alias RealTimeChatApp.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Accounts.get_user(user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> configure_session(drop: true)
  end

  def require_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: "/")
      |> halt()
    end
  end
end

defmodule RealTimeChatAppWeb.Auth.RequireUser do
  @moduledoc """
  Plug to require authenticated user.
  """
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
