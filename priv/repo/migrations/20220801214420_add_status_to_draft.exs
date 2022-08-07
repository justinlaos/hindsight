defmodule Histora.Repo.Migrations.AddStatusToDraft do
  use Ecto.Migration

  def change do
    alter table(:drafts) do
      add :converted, :boolean, default: false, null: false
    end
  end
end
