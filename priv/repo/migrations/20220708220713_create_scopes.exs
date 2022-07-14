defmodule Histora.Repo.Migrations.CreateScopes do
  use Ecto.Migration

  def change do
    create table(:scopes) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :name, :string

      timestamps()
    end
    create index(:scopes, [:organization_id])
  end
end
