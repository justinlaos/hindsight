defmodule Histora.Repo.Migrations.CreateScopeRecords do
  use Ecto.Migration

  def change do
    create table(:scope_records) do
      add :scope_id, references(:scopes, on_delete: :delete_all)
      add :record_id, references(:records, on_delete: :delete_all)

      timestamps()
    end

    create index(:scope_records, [:scope_id, :record_id])

  end
end
