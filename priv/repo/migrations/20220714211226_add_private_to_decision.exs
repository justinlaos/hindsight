defmodule Histora.Repo.Migrations.AddPrivateToDecision do
  use Ecto.Migration

  def change do
    alter table(:decisions) do
      add :private, :boolean, default: false, null: false
    end
  end
end
