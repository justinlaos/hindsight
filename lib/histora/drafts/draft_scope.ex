defmodule Histora.Drafts.Draft_scope do
  use Ecto.Schema
  import Ecto.Changeset

  schema "draft_scopes" do
    belongs_to(:draft, Histora.Drafts.Draft)
    belongs_to(:scope, Histora.Scopes.Scope)

    timestamps()
  end

  @doc false
  def changeset(draft_scope, attrs) do
    draft_scope
    |> cast(attrs, [:draft_id, :scope_id])
    |> validate_required([:draft_id, :scope_id])
  end
end
