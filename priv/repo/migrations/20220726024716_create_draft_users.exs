defmodule Histora.Repo.Migrations.CreateDraftUsers do
  use Ecto.Migration

  def change do
    create table(:draft_users) do
      add :draft_id, references(:drafts, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing), null: false


      timestamps()
    end

    create index(:draft_users, [:draft_id, :user_id])
  end
end
