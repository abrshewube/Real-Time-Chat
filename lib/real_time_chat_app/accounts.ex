defmodule RealTimeChatApp.Accounts do
  @moduledoc """
  The Accounts context handles user authentication and management.

  This is our "user service" - all user-related operations go through here.
  Keeps authentication logic separate from the web layer.
  """

  import Ecto.Query, warn: false
  alias RealTimeChatApp.Repo
  alias RealTimeChatApp.Accounts.User

  # Create a new user account
  # Returns {:ok, user} on success, {:error, changeset} on failure
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  # Find a user by their email address
  # Returns the user if found, nil otherwise
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  # Get a user by ID - returns nil if not found
  # Use this when the user might not exist
  def get_user(id) do
    Repo.get(User, id)
  end

  # Get a user by ID - raises if not found (hence the !)
  # Use this when you're sure the user exists
  def get_user!(id), do: Repo.get!(User, id)

  # Authenticate a user with email and password
  # Returns {:ok, user} if valid, {:error, reason} otherwise
  #
  # Security note: We use Pbkdf2 for password hashing (via Comeonin).
  # Even if someone steals our database, they can't get the passwords.
  def authenticate_user(email, password) do
    user = get_user_by_email(email)

    cond do
      # User exists AND password matches
      user && Pbkdf2.verify_pass(password, user.hashed_password) ->
        {:ok, user}

      # User exists but password is wrong
      user ->
        {:error, :invalid_password}

      # User doesn't exist - but we still verify password to prevent timing attacks
      # This makes it take the same amount of time whether user exists or not
      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
