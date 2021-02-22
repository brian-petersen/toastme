defmodule ToastMe.Repo.Migrations.CreateMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :sender_profile_id, references(:profiles)
      add :receiver_profile_id, references(:profiles)
      add :message, :text

      timestamps()
    end
  end
end
