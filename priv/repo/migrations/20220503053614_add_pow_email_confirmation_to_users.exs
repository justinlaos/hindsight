defmodule Histora.Repo.Migrations.AddPowEmailConfirmationToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email_confirmation_token, :string
      add :email_confirmed_at, :utc_datetime
      add :unconfirmed_email, :string
      add :role, :string, null: false, default: "user"
      add :archived_at, :utc_datetime
      add :invited_by_id, :integer
      add :invitation_accepted_at, :string
      add :invitation_token, :string

      add :organization_id, references(:organizations, on_delete: :nothing), null: false
    end

    create unique_index(:users, [:email_confirmation_token])
    create index(:users, [:organization_id])
  end
end
