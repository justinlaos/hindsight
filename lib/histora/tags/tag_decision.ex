defmodule Histora.Tags.Tag_decision do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tag_decisions" do
    belongs_to(:tag, Histora.Tags.Tag)
    belongs_to(:decision, Histora.Decisions.Decision)

    timestamps()
  end

  @doc false
  def changeset(tag_decision, attrs) do
    tag_decision
    |> cast(attrs, [:tag_id, :decision_id])
    |> validate_required([:tag_id, :decision_id])
  end
end
