defmodule Histora.Repo.Migrations.CreateDecisions do
  use Ecto.Migration

  def change do
    create table(:decisions) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :what, :text, null: false
      add :why, :text
      add :source, :string
      add :reference, :string
      add :date, :date
      add :reflection_date, :date

      timestamps()
    end
    create index(:decisions, [:organization_id, :user_id])
  end
end
