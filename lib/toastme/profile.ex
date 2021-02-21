defmodule ToastMe.Profile do
  use Ecto.Schema

  import Ecto.Changeset

  alias ToastMe.User

  schema "profiles" do
    field :bio, :string
    field :photos, {:array, :string}

    belongs_to(:user, User)

    timestamps()
  end

  @all_fields [:bio, :photos, :user_id]

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@all_fields)
    |> validate_length(:photos, min: 1, max: 5)
    |> unique_constraint(:user_id)
  end
end
