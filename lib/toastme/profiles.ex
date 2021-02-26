defmodule ToastMe.Profiles do
  import Ecto.Query, except: [update: 2]

  alias ToastMe.Match
  alias ToastMe.Profile
  alias ToastMe.Repo
  alias ToastMe.User

  def create(params) do
    params
    |> Profile.changeset()
    |> Repo.insert()
  end

  def create_or_update(%{user_id: user_id} = params) do
    {action, result} =
      case get_for_user(user_id) do
        nil -> {:create, create(params)}
        profile -> {:update, update(profile, params)}
      end

    case result do
      {:ok, profile} -> {:ok, profile, action}
      error -> error
    end
  end

  def get_for_user(%User{id: id}) do
    get_for_user(id)
  end

  def get_for_user(user_id) when is_integer(user_id) do
    Repo.get_by(Profile, user_id: user_id)
  end

  def get_potential_profiles_for_profile(%Profile{id: id}) do
    get_potential_profiles_for_profile(id)
  end

  def get_potential_profiles_for_profile(profile_id) when is_integer(profile_id) do
    already_matched_profile_ids =
      from p in Match,
        where: p.matcher_profile_id == ^profile_id,
        select: p.matched_profile_id

    query =
      from p in Profile,
        where: p.id not in subquery(already_matched_profile_ids),
        where: p.id != ^profile_id,
        limit: 100

    query
    |> Repo.all()
    |> Enum.shuffle()
  end

  def update(%Profile{} = profile, params) do
    profile
    |> Profile.changeset(params)
    |> Repo.update()
  end
end
