defmodule Histora.Repo.Migrations.AddReflectIdToDecisions do
  use Ecto.Migration

  def change do
    alter table(:decisions) do
      add :reflection_id, references(:reflections, on_delete: :nothing)
    end
  end
end
