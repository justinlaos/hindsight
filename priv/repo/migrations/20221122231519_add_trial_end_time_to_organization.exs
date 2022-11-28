defmodule Histora.Repo.Migrations.AddTrialEndTimeToOrganization do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :trial_expire_date, :date
    end
  end
end
