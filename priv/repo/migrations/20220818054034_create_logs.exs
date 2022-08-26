defmodule Histora.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :decision_id, references(:decisions, on_delete: :delete_all)
      add :draft_id, references(:drafts, on_delete: :delete_all)
      add :scope_id, references(:scopes, on_delete: :delete_all)
      add :event, :string

      timestamps()
    end

    create index(:logs, [:decision_id, :organization_id, :draft_id])
  end
end
