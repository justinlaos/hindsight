defmodule Histora.Repo.Migrations.AddWhyAndDateToDecision do
  use Ecto.Migration

  def change do
    alter table(:decisions) do
      add :date, :date
      add :why, :text
    end

    rename table(:decisions), :content, to: :what
  end
end
