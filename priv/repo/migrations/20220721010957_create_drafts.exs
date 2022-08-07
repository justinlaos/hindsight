defmodule Histora.Repo.Migrations.CreateDrafts do
  use Ecto.Migration

  def change do
    create table(:drafts) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :target_date, :date
      add :reference, :string
      add :title, :string
      add :description, :string

      timestamps()
    end

    create index(:drafts, [:organization_id, :user_id])
  end
end
