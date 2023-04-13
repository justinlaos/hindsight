defmodule Histora.Teams.Team_user do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_users" do
    belongs_to(:team, Histora.Teams.Team)
    belongs_to(:user, Histora.Users.User)

    timestamps()
  end

  @doc false
  def changeset(team_user, attrs) do
    team_user
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
  end
end
