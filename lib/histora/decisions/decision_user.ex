defmodule Histora.Decisions.Decision_user do
  use Ecto.Schema
  import Ecto.Changeset

  schema "decision_users" do
    belongs_to(:user, Histora.Users.User)
    belongs_to(:decision, Histora.Decisions.Decision)

    timestamps()
  end

  @doc false
  def changeset(decision_user, attrs) do
    decision_user
    |> cast(attrs, [:user_id, :decision_id])
    |> validate_required([:user_id, :decision_id])
  end
end
