defmodule Histora.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :event, :string
    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :decision, Histora.Decisions.Decision
    belongs_to :team, Histora.Teams.Team
    belongs_to :user, Histora.Users.User

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:event, :organization_id, :decision_id, :team_id, :user_id])
    |> validate_required([:user_id, :event, :organization_id])
  end
end
