defmodule RealTimeChatApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :hashed_password, :string
    field :password, :string, virtual: true  # Virtual field for password input (not stored in DB)
    field :avatar_color, :string, default: "#3b82f6"

    has_many :messages, RealTimeChatApp.Chat.Message
    timestamps()
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> validate_length(:username, min: 3, max: 20)
    |> validate_length(:password, min: 8)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> hash_password(opts)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :avatar_color])
    |> validate_required([:username])
    |> validate_length(:username, min: 3, max: 20)
    |> unique_constraint(:username)
  end

  defp hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password do
      changeset
      |> put_change(:hashed_password, Pbkdf2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
