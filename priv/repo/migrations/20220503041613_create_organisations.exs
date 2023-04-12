defmodule Histora.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :status, :string, null: false, default: "active"
      add :billing_email, :string, null: false
      add :user_limit, :integer, null: false
      add :stripe_product_id, :string, null: false
      add :stripe_price_id, :string, null: false
      add :stripe_customer_id, :string, null: false
      add :stripe_subscription_id, :string, null: false
      add :trial_expire_date, :date
      add :promo_code, :string
      timestamps()
    end
  end
end
