defmodule Histora.Scopes.Scope do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scopes" do
    field :name, :string
    field :private, :boolean
    belongs_to :organization, Histora.Organizations.Organization

    has_many(:scope_decisions, Histora.Scopes.Scope_decision)
    has_many(:decisions, through: [:scope_decisions, :decision])

    has_many(:scope_users, Histora.Scopes.Scope_user)
    has_many(:users, through: [:scope_users, :user])

    timestamps()
  end

  @doc false
  def changeset(scope, attrs) do
    scope
    |> cast(attrs, [:name, :organization_id, :private])
    |> validate_required([:name, :organization_id])
  end
end
