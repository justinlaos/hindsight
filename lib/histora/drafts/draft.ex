defmodule Histora.Drafts.Draft do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drafts" do
    field :title, :string
    field :description, :string
    field :target_date, :date
    field :reference, :string
    field :converted, :boolean

    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :user, Histora.Users.User

    has_many(:draft_options, Histora.Drafts.Draft_option)

    has_many(:draft_users, Histora.Drafts.Draft_user)
    has_many(:users, through: [:draft_users, :user])

    has_many(:draft_scopes, Histora.Drafts.Draft_scope)
    has_many(:scopes, through: [:draft_scopes, :scope])

    has_many(:draft_votes, Histora.Drafts.Draft_vote)

    has_many(:logs, Histora.Logs.Log)

    timestamps()
  end

  @doc false
  def changeset(draft, attrs) do
    draft
    |> cast(attrs, [:user_id, :organization_id, :title, :description, :target_date, :reference, :converted])
    |> validate_required([:user_id, :organization_id, :title, :description])
  end
end
