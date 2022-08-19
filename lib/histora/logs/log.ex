defmodule Histora.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :event, :string
    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :decision, Histora.Decisions.Decision
    belongs_to :draft, Histora.Drafts.Draft
    belongs_to :scope, Histora.Scopes.Scope
    belongs_to :user, Histora.Users.User

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:event, :organization_id, :decision_id, :draft_id, :scope_id, :user_id])
    |> validate_required([:user_id, :event, :organization_id])
  end
end
