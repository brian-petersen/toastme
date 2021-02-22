defmodule ToastMe.Match do
  use Ecto.Schema

  import Ecto.Changeset

  alias ToastMe.Profile

  schema "matches" do
    field :action, :string

    belongs_to :matcher_profile, Profile
    belongs_to :matched_profile, Profile

    timestamps()
  end

  @all_fields [:matcher_profile_id, :matched_profile_id, :action]

  def action_pass(), do: "pass"
  def action_roast(), do: "roast"

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@all_fields)
    |> validate_inclusion(:action, [action_pass(), action_roast()])
    |> validate_match()
    |> unique_constraint([:matcher_profile_id, :matched_profile_id])
  end

  defp validate_match(changeset) do
    matcher_profile_id = fetch_field(changeset, :matcher_profile_id)
    matched_profile_id = fetch_field(changeset, :matched_profile_id)

    if matcher_profile_id == matched_profile_id do
      add_error(changeset, :matcher_profile_id, "cannot match yourself")
    else
      changeset
    end
  end
end
