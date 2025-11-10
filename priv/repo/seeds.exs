alias RealTimeChatApp.{Accounts, Repo}

# Create some sample users for development
users = [
  %{
    email: "alice@example.com",
    username: "alice",
    password: "password123"
  },
  %{
    email: "bob@example.com",
    username: "bob",
    password: "password123"
  },
  %{
    email: "charlie@example.com",
    username: "charlie",
    password: "password123"
  }
]

for user_attrs <- users do
  case Accounts.get_user_by_email(user_attrs.email) do
    nil ->
      case Accounts.register_user(user_attrs) do
        {:ok, user} ->
          IO.puts("Created user: #{user.username}")

        {:error, changeset} ->
          IO.puts("Failed to create user #{user_attrs.username}: #{inspect(changeset.errors)}")
      end

    _user ->
      IO.puts("User #{user_attrs.username} already exists")
  end
end
