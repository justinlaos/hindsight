defmodule Hindsight.Decisions.Decision do
  use Ecto.Schema
  import Ecto.Changeset

  schema "decisions" do
    field :what, :string
    field :why, :string
    field :date, :date
    field :source, :string
    field :reference, :string
    field :reflection_date, :date

    belongs_to :organization, Hindsight.Organizations.Organization
    belongs_to :user, Hindsight.Users.User
    belongs_to :reflection, Hindsight.Reflections.Reflection

    has_many(:goal_decisions, Hindsight.Goals.Goal_decision)
    has_many(:goals, through: [:goal_decisions, :goal])

    has_many(:team_decisions, Hindsight.Teams.Team_decision)
    has_many(:teams, through: [:team_decisions, :team])

    has_many(:reflections, Hindsight.Reflections.Reflection)
    has_many(:reflection_goals, Hindsight.Reflections.Reflection_goal)
    has_many(:logs, Hindsight.Logs.Log)

    has_one(:approval, Hindsight.Decisions.Approval)

    timestamps()
  end

  @doc false
  def changeset(decision, attrs) do
    decision
    |> cast(attrs, [:user_id, :organization_id, :what, :why, :source, :reference, :date, :reflection_date, :reflection_id])
    |> validate_required([])
  end
end
