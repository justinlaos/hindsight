defmodule Hindsight.Repo.Migrations.CreateUserData do
  use Ecto.Migration

  def change do
    create table(:user_data) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :getting_started_completed, :boolean, default: false, null: false
      add :welcome_admin_completed, :boolean, default: false, null: false

      timestamps()
    end

    create index(:user_data, [:user_id])
  end
end
