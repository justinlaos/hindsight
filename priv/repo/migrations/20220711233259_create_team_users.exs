defmodule Hindsight.Repo.Migrations.CreateTeamUsers do
  use Ecto.Migration

  def change do
    create table(:team_users) do
      add :team_id, references(:teams, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing), null: false


      timestamps()
    end

    create index(:team_users, [:team_id, :user_id])
  end
end
