defmodule Histora.Repo.Migrations.CreateScopeDecisions do
  use Ecto.Migration

  def change do
    create table(:scope_decisions) do
      add :scope_id, references(:scopes, on_delete: :delete_all)
      add :decision_id, references(:decisions, on_delete: :delete_all)

      timestamps()
    end

    create index(:scope_decisions, [:scope_id, :decision_id])

  end
end
