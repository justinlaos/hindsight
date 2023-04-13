defmodule Histora.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:approvals) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :decision_id, references(:decisions, on_delete: :delete_all)
      add :note, :string
      add :approved, :boolean


      timestamps()
    end
  end
end
