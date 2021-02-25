defmodule ToastMe.Users do
  alias ToastMe.Repo
  alias ToastMe.User

  def register(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end

  def login(username, password) do
    with %User{} = user <- Repo.get_by(User, username: username),
         true <- User.has_password?(user, password) do
      {:ok, user}
    else
      _ -> {:error, "Username or password is invalid"}
    end
  end
end
