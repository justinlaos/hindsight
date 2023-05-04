defmodule Histora.Reflections.Reflection_goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reflection_goals" do
    field :achieved, :boolean
    belongs_to(:goal, Histora.Goals.Goal)
    belongs_to(:reflection, Histora.Reflections.Reflection)
    belongs_to(:decision, Histora.Decisions.Decision)
    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :user, Histora.Users.User

    timestamps()
  end

  @doc false
  def changeset(reflection_goal, attrs) do
    reflection_goal
    |> cast(attrs, [:achieved, :goal_id, :reflection_id, :decision_id, :user_id, :organization_id])
    |> validate_required([:achieved, :goal_id, :reflection_id, :decision_id, :user_id, :organization_id])
  end
end
