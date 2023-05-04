defmodule Histora.Repo.Migrations.RenameTagDecisionsTableToGoalDecisions do
  use Ecto.Migration

  def change do
    rename table("tag_decisions"), to: table("goal_decisions")
    alter table("goal_decisions") do
      remove :tag_id
      add :goal_id, references(:goals, on_delete: :delete_all)
    end
  end
end
