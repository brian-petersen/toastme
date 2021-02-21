defmodule ToastMe.Repo.Migrations.CreateProfilesTable do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :user_id, references(:users)
      add :bio, :text
      add :photos, {:array, :text}

      timestamps()
    end

    create unique_index(:profiles, :user_id)
  end
end
