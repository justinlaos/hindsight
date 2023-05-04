defmodule Histora.Repo.Migrations.RenameTagTableToGoal do
  use Ecto.Migration

  def change do
    rename table("tags"), to: table("goals")
  end
end
