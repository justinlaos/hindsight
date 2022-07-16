defmodule Histora.Repo.Migrations.CreateRecordUsers do
  use Ecto.Migration

  def change do
    create table(:record_users) do
      add :record_id, references(:records, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:record_users, [:record_id, :user_id])
  end
end
