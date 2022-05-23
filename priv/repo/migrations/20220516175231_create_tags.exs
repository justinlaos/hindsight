defmodule Histora.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :name, :string


      timestamps()
    end

    create index(:tags, [:organization_id])
    create unique_index(:tags, [:organization_id, :name], name: :your_index_name)
  end
end
