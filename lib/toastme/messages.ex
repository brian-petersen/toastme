defmodule ToastMe.Messages do
  import Ecto.Query

  alias ToastMe.Message
  alias ToastMe.Repo

  def create(params) do
    params
    |> Message.changeset()
    |> Repo.insert()
  end

  def get_messages_between_profiles(profile1_id, profile2_id) do
    query =
      from m in Message,
        where: m.sender_profile_id == ^profile1_id and m.receiver_profile_id == ^profile2_id,
        or_where: m.sender_profile_id == ^profile2_id and m.receiver_profile_id == ^profile1_id,
        order_by: m.inserted_at

    Repo.all(query)
  end
end
