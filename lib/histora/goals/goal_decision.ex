defmodule Histora.Goals.Goal_decision do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goal_decisions" do
    belongs_to(:goal, Histora.Goals.Goal)
    belongs_to(:decision, Histora.Decisions.Decision)

    timestamps()
  end

  @doc false
  def changeset(tag_decision, attrs) do
    tag_decision
    |> cast(attrs, [:goal_id, :decision_id])
    |> validate_required([:goal_id, :decision_id])
  end
end
