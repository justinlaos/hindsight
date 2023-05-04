defmodule Histora.Goals.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field :name, :string
    field :decisions_count, :integer, virtual: true

    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :user, Histora.Users.User

    has_many(:goal_decisions, Histora.Goals.Goal_decision)
    has_many(:decisions, through: [:goal_decisions, :decision])
    has_many(:reflection_goals, Histora.Reflections.Reflection_goal)

    timestamps()
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:name, :user_id, :organization_id])
    |> validate_required([:name, :user_id, :organization_id])
  end
end
