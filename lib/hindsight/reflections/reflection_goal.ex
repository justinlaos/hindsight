defmodule Hindsight.Reflections.Reflection_goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reflection_goals" do
    field :achieved, :boolean
    belongs_to(:goal, Hindsight.Goals.Goal)
    belongs_to(:reflection, Hindsight.Reflections.Reflection)
    belongs_to(:decision, Hindsight.Decisions.Decision)
    belongs_to :organization, Hindsight.Organizations.Organization
    belongs_to :user, Hindsight.Users.User

    timestamps()
  end

  @doc false
  def changeset(reflection_goal, attrs) do
    reflection_goal
    |> cast(attrs, [:achieved, :goal_id, :reflection_id, :decision_id, :user_id, :organization_id])
    |> validate_required([:achieved, :goal_id, :reflection_id, :decision_id, :user_id, :organization_id])
  end
end
