defmodule Hindsight.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :private, :boolean
    belongs_to :organization, Hindsight.Organizations.Organization

    has_many(:team_decisions, Hindsight.Teams.Team_decision)
    has_many(:decisions, through: [:team_decisions, :decision])

    has_many(:team_users, Hindsight.Teams.Team_user)
    has_many(:users, through: [:team_users, :user])

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :organization_id, :private])
    |> validate_required([:name, :organization_id])
  end
end
