defmodule Histora.Tags.Tag_record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tag_records" do
    belongs_to(:tag, Histora.Tags.Tag)
    belongs_to(:record, Histora.Records.Record)

    timestamps()
  end

  @doc false
  def changeset(tag_record, attrs) do
    tag_record
    |> cast(attrs, [:tag_id, :record_id])
    |> validate_required([:tag_id, :record_id])
  end
end
