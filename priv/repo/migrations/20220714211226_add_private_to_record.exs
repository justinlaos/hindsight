defmodule Histora.Repo.Migrations.AddPrivateToRecord do
  use Ecto.Migration

  def change do
    alter table(:records) do
      add :private, :boolean, default: false, null: false
    end
  end
end
