defmodule ToastMe.Message do
  use Ecto.Schema

  import Ecto.Changeset

  alias ToastMe.Profile

  schema "messages" do
    field :message, :string

    belongs_to :sender_profile, Profile
    belongs_to :receiver_profile, Profile

    timestamps()
  end

  @all_fields [:sender_profile_id, :receiver_profile_id, :message]

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@all_fields)
  end
end
