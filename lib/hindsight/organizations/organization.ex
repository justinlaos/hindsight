defmodule Hindsight.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :status, :string, default: "active"
    field :user_limit, :integer
    field :trial_expire_date, :date
    field :billing_email, :string
    field :stripe_product_id, :string
    field :stripe_price_id, :string
    field :stripe_customer_id, :string
    field :stripe_subscription_id, :string
    field :promo_code, :string

    has_many :users, Hindsight.Users.User
    has_many :decisions, Hindsight.Decisions.Decision

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :status, :user_limit, :trial_expire_date, :billing_email, :stripe_product_id, :stripe_price_id, :stripe_customer_id, :stripe_subscription_id, :promo_code])
    |> validate_required([])
  end
end
