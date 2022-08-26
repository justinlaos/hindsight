defmodule Histora.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  alias Ecto.{Changeset, Schema}
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowInvitation]

  schema "users" do
    field :role, :string, default: "user"
    field :archived_at, :utc_datetime
    belongs_to(:organization, Histora.Organizations.Organization)
    has_many(:decisions, Histora.Decisions.Decision)
    has_many(:user_favorites, Histora.Users.User_favorite)
    has_many(:user_data, Histora.Users.User_data)

    has_many(:scope_users, Histora.Scopes.Scope_user)
    has_many(:scopes, through: [:scope_users, :scope])
    has_many(:draft_votes, Histora.Drafts.Draft_vote)

    pow_user_fields()
    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role, :organization_id])
    |> Ecto.Changeset.validate_inclusion(:role, ~w(user admin))
  end

  def archive_changeset(user_or_changeset) do
    changeset = Changeset.change(user_or_changeset)
    archived_at = DateTime.truncate(DateTime.utc_now(), :second)

    case Changeset.get_field(changeset, :archived_at) do
      nil  -> Changeset.change(changeset, archived_at: archived_at)
      _any -> Changeset.add_error(changeset, :archived_at, "already set")
    end
  end

  def unarchive_changeset(user_or_changeset) do
    changeset = Changeset.change(user_or_changeset)

    Changeset.change(changeset, archived_at: nil)
  end

  def invite_changeset(user_or_changeset, invited_by, attrs) do
    user_or_changeset
    |> pow_invite_changeset(invited_by, attrs)
    |> changeset_organization(invited_by)
  end

  defp changeset_organization(changeset, invited_by) do
    Ecto.Changeset.change(changeset, organization_id: invited_by.organization_id)
  end
end
