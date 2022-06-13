defmodule Histora.Repo.Migrations.AddUsersDetails do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, null: false, default: "user"
      add :archived_at, :utc_datetime
      add :invited_by_id, :integer
      add :invitation_accepted_at, :string
      add :invitation_token, :string

      add :organization_id, references(:organizations, on_delete: :nothing), null: false
    end

    create index(:users, [:organization_id])
  end
end
