defmodule Histora.Scopes.Scope_user do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scope_users" do
    belongs_to(:scope, Histora.Scopes.Scope)
    belongs_to(:user, Histora.Users.User)

    timestamps()
  end

  @doc false
  def changeset(scope_user, attrs) do
    scope_user
    |> cast(attrs, [:user_id, :scope_id])
    |> validate_required([:user_id, :scope_id])
  end
end
