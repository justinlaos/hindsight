defmodule Hindsight.Decisions.Approval do
  use Ecto.Schema
  import Ecto.Changeset

  schema "approvals" do
    field :approved, :boolean
    field :note, :string
    belongs_to :organization, Hindsight.Organizations.Organization
    belongs_to :user, Hindsight.Users.User
    belongs_to :decision, Hindsight.Decisions.Decision

    timestamps()
  end

  @doc false
  def changeset(approval, attrs) do
    approval
    |> cast(attrs, [:user_id, :organization_id, :decision_id, :approved, :note])
    |> validate_required([])
  end
end
