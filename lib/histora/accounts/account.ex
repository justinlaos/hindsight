defmodule Histora.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :admin_email, :string
    field :name, :string, default: "Orginization Name"
    field :stripe_customer_id, :string
    field :stripe_product_id, :string
    field :stripe_price_id, :string
    field :user_seats, :integer, default: 0
    field :active, :boolean, default: false

    has_many(:users, Histora.Users.User)

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:admin_email, :name, :stripe_customer_id, :stripe_product_id, :stripe_price_id, :user_seats, :active])
    |> validate_required([])
  end
end
