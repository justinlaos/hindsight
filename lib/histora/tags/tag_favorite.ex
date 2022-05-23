defmodule Histora.Tags.Tag_favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tag_favorites" do
    belongs_to(:tag, Histora.Tags.Tag)
    belongs_to(:user, Histora.Users.User)

    timestamps()
  end

  @doc false
  def changeset(tag_favorite, attrs) do
    tag_favorite
    |> cast(attrs, [:user_id, :tag_id])
    |> validate_required([:user_id, :tag_id])
  end
end
