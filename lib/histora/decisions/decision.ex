defmodule Histora.Decisions.Decision do
  use Ecto.Schema
  import Ecto.Changeset

  schema "decisions" do
    field :what, :string
    field :why, :string
    field :date, :date
    field :source, :string
    field :reference, :string
    field :private, :boolean
    field :reflection_date, :date
    field :reflection_type, :string

    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :draft, Histora.Drafts.Draft
    belongs_to :user, Histora.Users.User

    has_many(:tag_decisions, Histora.Tags.Tag_decision)
    has_many(:tags, through: [:tag_decisions, :tag])

    has_many(:scope_decisions, Histora.Scopes.Scope_decision)
    has_many(:scopes, through: [:scope_decisions, :scope])

    has_many(:decision_users, Histora.Decisions.Decision_user)
    has_many(:users, through: [:decision_users, :user])

    has_many(:reflections, Histora.Reflections.Reflection)
    has_many(:logs, Histora.Logs.Log)

    timestamps()
  end

  @doc false
  def changeset(decision, attrs) do
    decision
    |> cast(attrs, [:user_id, :organization_id, :what, :why, :source, :reference, :private, :draft_id, :date, :reflection_date, :reflection_type])
    |> validate_required([])
  end
end
