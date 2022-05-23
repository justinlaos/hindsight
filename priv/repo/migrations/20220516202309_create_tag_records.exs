defmodule Histora.Repo.Migrations.CreateTagRecords do
  use Ecto.Migration

  def change do
    create table(:tag_records) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :record_id, references(:records, on_delete: :delete_all)

      timestamps()
    end

    create index(:tag_records, [:tag_id, :record_id])
  end
end
