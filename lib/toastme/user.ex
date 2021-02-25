defmodule ToastMe.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias ToastMe.Profile

  schema "users" do
    field :username, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_one(:profile, Profile)

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:username, :password, :password_confirmation])
    |> validate_required([:username, :password, :password_confirmation])
    |> validate_length(:username, min: 3, max: 60)
    |> validate_length(:password, min: 8, max: 60)
    |> validate_passwords()
    |> hash_password()
    |> unique_constraint(:username)
  end

  def has_password?(%__MODULE__{password_hash: hash}, password) do
    Bcrypt.verify_pass(password, hash)
  end

  defp hash_password(%{valid?: true} = changeset) do
    password = get_field(changeset, :password)
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset) do
    changeset
  end

  defp validate_passwords(%{valid?: true} = changeset) do
    password = get_field(changeset, :password)
    password_confirmation = get_field(changeset, :password_confirmation)

    if password == password_confirmation do
      changeset
    else
      add_error(changeset, :password, "does not match password confirmation")
    end
  end

  defp validate_passwords(changeset) do
    changeset
  end
end
