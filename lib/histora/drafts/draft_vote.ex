defmodule Histora.Drafts.Draft_vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "draft_votes" do
    belongs_to(:draft, Histora.Drafts.Draft)
    belongs_to(:draft_option, Histora.Drafts.Draft_option)
    belongs_to(:user, Histora.Users.User)

    timestamps()
  end

  @doc false
  def changeset(draft_vote, attrs) do
    draft_vote
    |> cast(attrs, [:user_id, :draft_id, :draft_option_id])
    |> validate_required([:user_id, :draft_id, :draft_option_id])
  end
end
