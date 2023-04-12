defmodule Histora.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :private, :boolean, default: false, null: false
      add :name, :string

      timestamps()
    end
    create index(:teams, [:organization_id])
  end
end
