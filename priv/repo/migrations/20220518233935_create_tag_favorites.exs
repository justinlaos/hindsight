defmodule Histora.Repo.Migrations.CreateTagFavorites do
  use Ecto.Migration

  def change do
    create table(:tag_favorites) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:tag_favorites, [:tag_id, :user_id])
  end
end
