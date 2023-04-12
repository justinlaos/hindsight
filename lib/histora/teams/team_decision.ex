defmodule Histora.Teams.Team_decision do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_decisions" do
    belongs_to(:team, Histora.Teams.Team)
    belongs_to(:decision, Histora.Decisions.Decision)


    timestamps()
  end

  @doc false
  def changeset(team_decision, attrs) do
    team_decision
    |> cast(attrs, [:team_id, :decision_id])
    |> validate_required([:team_id, :decision_id])
  end
end
