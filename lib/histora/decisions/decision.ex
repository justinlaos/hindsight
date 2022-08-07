defmodule Histora.Decisions.Decision do
  use Ecto.Schema
  import Ecto.Changeset

  schema "decisions" do
    field :content, :string
    field :source, :string
    field :reference, :string
    field :private, :boolean

    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :draft, Histora.Drafts.Draft
    belongs_to :user, Histora.Users.User

    has_many(:tag_decisions, Histora.Tags.Tag_decision)
    has_many(:tags, through: [:tag_decisions, :tag])

    has_many(:scope_decisions, Histora.Scopes.Scope_decision)
    has_many(:scopes, through: [:scope_decisions, :scope])

    has_many(:decision_users, Histora.Decisions.Decision_user)
    has_many(:users, through: [:decision_users, :user])

    timestamps()
  end

  @doc false
  def changeset(decision, attrs) do
    decision
    |> cast(attrs, [:user_id, :organization_id, :content, :source, :reference, :private, :draft_id])
    |> validate_required([])
  end
end
