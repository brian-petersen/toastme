defmodule ToastMe.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :facebook_user_id, :text
      add :email, :text
      add :name, :text

      timestamps()
    end

    create unique_index(:users, :facebook_user_id)
  end
end
