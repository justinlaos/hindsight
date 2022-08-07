defmodule Histora.Repo.Migrations.CreateDecisionUsers do
  use Ecto.Migration

  def change do
    create table(:decision_users) do
      add :decision_id, references(:decisions, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:decision_users, [:decision_id, :user_id])
  end
end
