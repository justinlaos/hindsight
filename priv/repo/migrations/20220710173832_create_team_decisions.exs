defmodule Hindsight.Repo.Migrations.CreateTeamDecisions do
  use Ecto.Migration

  def change do
    create table(:team_decisions) do
      add :team_id, references(:teams, on_delete: :delete_all)
      add :decision_id, references(:decisions, on_delete: :delete_all)

      timestamps()
    end

    create index(:team_decisions, [:team_id, :decision_id])

  end
end
