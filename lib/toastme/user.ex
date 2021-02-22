defmodule ToastMe.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias ToastMe.Profile

  schema "users" do
    field :facebook_user_id, :string
    field :email, :string
    field :name, :string

    has_one(:profile, Profile)

    timestamps()
  end

  @required_fields [:facebook_user_id, :name]
  @all_fields @required_fields ++ [:email]

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
  end
end
