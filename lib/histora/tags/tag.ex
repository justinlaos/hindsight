defmodule Histora.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    field :decisions_count, :integer, virtual: true

    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :user, Histora.Users.User

    has_many(:tag_decisions, Histora.Tags.Tag_decision)
    has_many(:decisions, through: [:tag_decisions, :decision])

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :user_id, :organization_id])
    |> validate_required([:name, :user_id, :organization_id])
  end
end
