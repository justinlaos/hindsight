defmodule Histora.Repo.Migrations.CreateDraftScopes do
  use Ecto.Migration

  def change do
    create table(:draft_scopes) do
      add :draft_id, references(:drafts, on_delete: :delete_all)
      add :scope_id, references(:scopes, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:draft_scopes, [:draft_id, :scope_id])
  end
end
