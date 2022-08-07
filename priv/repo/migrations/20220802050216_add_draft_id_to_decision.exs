defmodule Histora.Repo.Migrations.AddDraftIdToDecision do
  use Ecto.Migration

  def change do
    alter table(:decisions) do
      add :draft_id, references(:drafts, on_delete: :nothing)
    end
  end
end
