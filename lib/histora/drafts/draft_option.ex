defmodule Histora.Drafts.Draft_option do
  use Ecto.Schema
  import Ecto.Changeset

  schema "draft_options" do
    field :content, :string

    belongs_to(:draft, Histora.Drafts.Draft)
    belongs_to(:user, Histora.Users.User)

    has_many(:draft_votes, Histora.Drafts.Draft_vote)

    timestamps()
  end

  @doc false
  def changeset(draft_option, attrs) do
    draft_option
    |> cast(attrs, [:content, :user_id, :draft_id])
    |> validate_required([:content, :user_id, :draft_id])
  end
end
