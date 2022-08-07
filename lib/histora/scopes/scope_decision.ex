defmodule Histora.Scopes.Scope_decision do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scope_decisions" do
    belongs_to(:scope, Histora.Scopes.Scope)
    belongs_to(:decision, Histora.Decisions.Decision)


    timestamps()
  end

  @doc false
  def changeset(scope_decision, attrs) do
    scope_decision
    |> cast(attrs, [:scope_id, :decision_id])
    |> validate_required([:scope_id, :decision_id])
  end
end
