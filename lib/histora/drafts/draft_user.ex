defmodule Histora.Drafts.Draft_user do
  use Ecto.Schema
  import Ecto.Changeset

  schema "draft_users" do
    belongs_to(:draft, Histora.Drafts.Draft)
    belongs_to(:user, Histora.Users.User)

    timestamps()
  end

  @doc false
  def changeset(draft_user, attrs) do
    draft_user
    |> cast(attrs, [:user_id, :draft_id])
    |> validate_required([:user_id, :draft_id])
  end
end
