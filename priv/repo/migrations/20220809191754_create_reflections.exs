defmodule Histora.Repo.Migrations.CreateReflections do
  use Ecto.Migration

  def change do
    create table(:reflections) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :decision_id, references(:decisions, on_delete: :delete_all)
      add :content, :text, null: false
      add :status, :string, null: false

      timestamps()
    end

    create index(:reflections, [:decision_id, :user_id])

    alter table(:decisions) do
      add :reflection_id, references(:reflections, on_delete: :nothing)
    end
  end
end
