defmodule Histora.Decisions.Decision do
  use Ecto.Schema
  import Ecto.Changeset

  schema "decisions" do
    field :what, :string
    field :why, :string
    field :date, :date
    field :source, :string
    field :reference, :string
    field :reflection_date, :date

    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :user, Histora.Users.User
    belongs_to :reflection, Histora.Reflections.Reflection

    has_many(:tag_decisions, Histora.Tags.Tag_decision)
    has_many(:tags, through: [:tag_decisions, :tag])

    has_many(:team_decisions, Histora.Teams.Team_decision)
    has_many(:teams, through: [:team_decisions, :team])

    has_many(:reflections, Histora.Reflections.Reflection)
    has_many(:logs, Histora.Logs.Log)

    has_one(:approval, Histora.Decisions.Approval)

    timestamps()
  end

  @doc false
  def changeset(decision, attrs) do
    decision
    |> cast(attrs, [:user_id, :organization_id, :what, :why, :source, :reference, :date, :reflection_date, :reflection_id])
    |> validate_required([])
  end
end
