defmodule Hindsight.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string
      add :role, :string, null: false, default: "user"
      add :archived_at, :utc_datetime
      add :invited_by_id, :integer
      add :invitation_accepted_at, :utc_datetime
      add :invitation_token, :string
      add :organization_id, references(:organizations, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:users, [:email, :organization_id])
  end
end
