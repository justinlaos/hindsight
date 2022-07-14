defmodule Histora.Scopes.Scope do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scopes" do
    field :name, :string
    belongs_to :organization, Histora.Organizations.Organization

    has_many(:scope_records, Histora.Scopes.Scope_record)
    has_many(:records, through: [:scope_records, :record])

    has_many(:scope_users, Histora.Scopes.Scope_user)
    has_many(:users, through: [:scope_users, :user])

    timestamps()
  end

  @doc false
  def changeset(scope, attrs) do
    scope
    |> cast(attrs, [:name, :organization_id])
    |> validate_required([:name, :organization_id])
  end
end
