defmodule Histora.Repo.Migrations.AddPromoCodeToOrganization do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :promo_code, :string
    end
  end
end
