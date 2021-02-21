defmodule ToastMe.Profiles do
  alias ToastMe.Profile
  alias ToastMe.Repo
  alias ToastMe.User

  def create(params) do
    params
    |> Profile.changeset()
    |> Repo.insert()
  end

  def get_for_user(%User{id: id}) do
    get_for_user(id)
  end

  def get_for_user(user_id) when is_integer(user_id) do
    Repo.get_by(Profile, user_id: user_id)
  end
end
