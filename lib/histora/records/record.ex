defmodule Histora.Records.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :content, :string
    field :source, :string
    field :reference, :string

    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :user, Histora.Users.User
    has_many(:tag_records, Histora.Tags.Tag_record)
    has_many(:tags, through: [:tag_records, :tag])

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:user_id, :organization_id, :content, :source, :reference])
    |> validate_required([])
  end
end
