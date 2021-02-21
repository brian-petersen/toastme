defmodule ToastMe.Users do
  alias ToastMe.Repo
  alias ToastMe.User
  alias Ueberauth.Auth

  def find_or_create(%Auth{
        uid: uid,
        info: %{email: email, name: name},
        provider: :facebook
      }) do
    %{
      facebook_user_id: uid,
      email: email,
      name: name
    }
    |> User.changeset()
    |> Repo.insert(
      on_conflict: [set: [facebook_user_id: uid]],
      conflict_target: :facebook_user_id
    )
  end
end
