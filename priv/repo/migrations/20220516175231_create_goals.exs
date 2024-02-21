defmodule Hindsight.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :name, :string


      timestamps()
    end

    create index(:goals, [:organization_id])
    create unique_index(:goals, [:organization_id, :name], name: :your_index_name)
  end
end
