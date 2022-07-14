defmodule Histora.Repo.Migrations.CreateScopeUsers do
  use Ecto.Migration

  def change do
    create table(:scope_users) do
      add :scope_id, references(:scopes, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing), null: false


      timestamps()
    end

    create index(:scope_users, [:scope_id, :user_id])
  end
end
