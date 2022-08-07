defmodule Histora.Repo.Migrations.CreateDraftVotes do
  use Ecto.Migration

  def change do
    create table(:draft_votes) do
      add :draft_id, references(:drafts, on_delete: :delete_all)
      add :draft_option_id, references(:draft_options, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
