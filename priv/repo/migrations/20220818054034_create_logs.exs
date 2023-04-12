defmodule Histora.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :decision_id, references(:decisions, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :delete_all)
      add :event, :string

      timestamps()
    end

    create index(:logs, [:decision_id, :organization_id])
  end
end
