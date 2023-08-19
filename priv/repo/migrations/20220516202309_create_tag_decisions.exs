defmodule Histora.Repo.Migrations.CreateGoalDecisions do
  use Ecto.Migration

  def change do
    create table(:goal_decisions) do
      add :goal_id, references(:goals, on_delete: :delete_all)
      add :decision_id, references(:decisions, on_delete: :delete_all)

      timestamps()
    end

    create index(:goal_decisions, [:goal_id, :decision_id])
  end
end
