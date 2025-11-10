defmodule RealTimeChatAppWeb.SessionController do
  use RealTimeChatAppWeb, :controller

  alias RealTimeChatApp.Accounts
  alias RealTimeChatAppWeb.Auth

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: "/chat")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: "/")
    end
  end

  def register(conn, %{"email" => email, "username" => username, "password" => password}) do
    case Accounts.register_user(%{
           email: email,
           username: username,
           password: password
         }) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "Account created successfully!")
        |> redirect(to: "/chat")

      {:error, changeset} ->
        errors =
          changeset.errors
          |> Enum.map(fn {field, {msg, _}} -> "#{field}: #{msg}" end)
          |> Enum.join(", ")

        conn
        |> put_flash(:error, "Registration failed: #{errors}")
        |> redirect(to: "/")
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: "/")
  end
end
