defmodule Hindsight.Repo.Migrations.AddReflectionGoalsTable do
  use Ecto.Migration

  def change do
    create table(:reflection_goals) do
      add :achieved, :boolean, default: false, null: false
      add :reflection_id, references(:reflections, on_delete: :delete_all)
      add :goal_id, references(:goals, on_delete: :delete_all)
      add :decision_id, references(:decisions, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing)
      add :organization_id, references(:organizations, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:reflection_goals, [:reflection_id, :goal_id, :user_id])

  end
end
