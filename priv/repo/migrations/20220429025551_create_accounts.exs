defmodule Histora.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:accounts) do
      add :admin_email, :citext, null: false
      add :name, :string, null: false, default: "Orginization Name"
      add :stripe_customer_id, :string, null: false
      add :stripe_product_id, :string, null: false
      add :stripe_price_id, :string, null: false
      add :user_seats, :integer, default: 0
      add :active, :boolean, null: false, default: false

      timestamps()
    end

    create unique_index(:accounts, [:admin_email, :stripe_customer_id])
  end
end
