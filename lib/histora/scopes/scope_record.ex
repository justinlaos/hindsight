defmodule Histora.Scopes.Scope_record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scope_records" do
    belongs_to(:scope, Histora.Scopes.Scope)
    belongs_to(:record, Histora.Records.Record)


    timestamps()
  end

  @doc false
  def changeset(scope_record, attrs) do
    scope_record
    |> cast(attrs, [:scope_id, :record_id])
    |> validate_required([:scope_id, :record_id])
  end
end
