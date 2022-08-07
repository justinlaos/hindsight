defmodule Histora.Repo.Migrations.CreateDraftOptions do
  use Ecto.Migration

  def change do
    create table(:draft_options) do
      add :draft_id, references(:drafts, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :content, :text, null: false

      timestamps()
    end

    create index(:draft_options, [:draft_id])
  end
end
