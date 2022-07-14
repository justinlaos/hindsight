defmodule Histora.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    field :records_count, :integer, virtual: true

    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :user, Histora.Users.User

    has_many(:tag_records, Histora.Tags.Tag_record)
    has_many(:tag_favorites, Histora.Tags.Tag_favorite)
    has_many(:records, through: [:tag_records, :record])

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :user_id, :organization_id])
    |> validate_required([:name, :user_id, :organization_id])
  end
end
