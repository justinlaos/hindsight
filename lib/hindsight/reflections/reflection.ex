defmodule Hindsight.Reflections.Reflection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reflections" do
    field :content, :string
    field :status, :string

    belongs_to :organization, Hindsight.Organizations.Organization
    belongs_to :decision, Hindsight.Decisions.Decision
    belongs_to :user, Hindsight.Users.User

    has_many(:decisions, Hindsight.Decisions.Decision)

    has_many(:reflection_goals, Hindsight.Reflections.Reflection_goal)


    timestamps()
  end

  @doc false
  def changeset(reflection, attrs) do
    reflection
    |> cast(attrs, [:user_id, :organization_id, :decision_id, :content, :status])
    |> validate_required([])
  end
end
