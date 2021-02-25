defmodule ToastMe.Repo.Migrations.RecreateUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :facebook_user_id
      remove :email
      remove :name

      add :username, :text, null: false
      add :password_hash, :text, null: false
    end

    create unique_index(:users, :username)
  end
end
