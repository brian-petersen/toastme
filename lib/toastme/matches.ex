defmodule ToastMe.Matches do
  import Ecto.Query

  alias ToastMe.Match
  alias ToastMe.Profile
  alias ToastMe.Repo

  def create(params) do
    params
    |> Match.changeset()
    |> Repo.insert()
  end

  def get_matches_for_profile(%Profile{id: id}) do
    get_matches_for_profile(id)
  end

  def get_matches_for_profile(profile_id) when is_integer(profile_id) do
    potential_roast_profile_ids =
      from m in Match,
        where: m.matched_profile_id == ^profile_id,
        where: m.action == ^Match.action_roast(),
        select: m.matcher_profile_id

    query =
      from m in Match,
        join: p in assoc(m, :matched_profile),
        where: m.matcher_profile_id == ^profile_id,
        where: m.action == ^Match.action_roast(),
        where: m.matched_profile_id in subquery(potential_roast_profile_ids),
        preload: [matched_profile: p]

    Repo.all(query)
  end
end
