defmodule Histora.Repo.Migrations.CreateTagDecisions do
  use Ecto.Migration

  def change do
    create table(:tag_decisions) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :decision_id, references(:decisions, on_delete: :delete_all)

      timestamps()
    end

    create index(:tag_decisions, [:tag_id, :decision_id])
  end
end
