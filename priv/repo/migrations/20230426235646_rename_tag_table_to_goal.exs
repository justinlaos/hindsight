defmodule Histora.Repo.Migrations.RenameGoalTableToGoal do
  use Ecto.Migration

  def change do
    rename table("goals"), to: table("goals")
  end
end
