defmodule ToastMe.Repo.Migrations.CreateMatchesTable do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :matcher_profile_id, references(:profiles)
      add :matched_profile_id, references(:profiles)
      add :action, :text

      timestamps()
    end

    create unique_index(:matches, [:matcher_profile_id, :matched_profile_id])
  end
end
