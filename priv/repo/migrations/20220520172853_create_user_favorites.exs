defmodule Histora.Repo.Migrations.CreateUserFavorites do
  use Ecto.Migration

  def change do
    create table(:user_favorites) do
      add :favorite_user_id, references(:users, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:user_favorites, [:favorite_user_id, :user_id])
  end
end
