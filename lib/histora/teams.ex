defmodule Histora.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias Histora.Repo

  alias Histora.Teams.Team
  alias Histora.Users.User
  alias Histora.Decisions
  alias Histora.Decisions.Decision
  alias Histora.Decisions.Decision_user
  alias Histora.Teams.Team_user

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  def list_all_organization_teams(organization, current_user) do
    (from s in Team, where: s.organization_id == ^organization.id, preload: [:users, :decisions] ) |> Repo.all()
  end

  def list_organization_teams(organization, current_user) do
    if current_user.role == "admin" do
      (from s in Team, where: s.organization_id == ^organization.id, preload: [:users, :decisions] ) |> Repo.all()
    else
      user_team = (from su in Team_user, where: su.user_id == ^current_user.id, select: su.team_id) |> Repo.all()
      (from s in Team,
        where: s.organization_id == ^organization.id,
        where: s.id in ^user_team or s.private == false)
      |> Repo.all()
    end
  end

  def selected_filtered_teams(organization, team) do
    (from s in Team,
      where: s.organization_id == ^organization.id,
      where: s.id == ^(String.to_integer(team))
    )
    |> Repo.one()
  end

  def list_user_teams(current_user) do
    Ecto.assoc(Repo.get(User, current_user.id), :teams) |> Repo.all
  end

  def delete_team_from_decision(decision_id) do
    Ecto.assoc(Repo.get(Decision, decision_id), :team_decisions) |> Repo.delete_all
  end

  def assign_teams_to_decision(team, decision_id) do
    case Repo.get(Team, team) do
      team -> create_team_decision(%{"team_id" => team.id, "decision_id" => decision_id})
    end
  end

  def assign_teams_from_draft_to_decision(teams, decision_id) do
    for team <- teams do
      case Repo.get(Team, team.id) do
        team -> create_team_decision(%{"team_id" => team.id, "decision_id" => decision_id})
      end
    end
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)


  def get_decisions_for_team(id) do
    (Repo.all Ecto.assoc(Repo.get(Team, id), :decisions))
    |> Repo.preload([:user, :goals, :users, :teams])
    |> Enum.group_by(& &1.date)
    |> Enum.map(fn {date, decisions_collection} -> %{date: date, decisions: decisions_collection} end)
    |> Enum.sort_by(&(&1.date), {:desc, Date})
  end


  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    cleaned_team = (attrs["name"] |> String.downcase(:ascii) |> String.trim(" "))
    case Repo.exists?((from s in Team, where: s.organization_id == ^attrs["organization_id"] and s.name == ^cleaned_team )) do
      false -> %Team{} |> Team.changeset(Map.merge(attrs, %{"name" => cleaned_team})) |> Repo.insert()
      true -> {:error, "Team already exists."}
    end
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  alias Histora.Teams.Team_decision

  @doc """
  Returns the list of team_decisions.

  ## Examples

      iex> list_team_decisions()
      [%Team_decision{}, ...]

  """
  def list_team_decisions do
    Repo.all(Team_decision)
  end

  @doc """
  Gets a single team_decision.

  Raises `Ecto.NoResultsError` if the Team decision does not exist.

  ## Examples

      iex> get_team_decision!(123)
      %Team_decision{}

      iex> get_team_decision!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_decision!(id), do: Repo.get!(Team_decision, id)

  @doc """
  Creates a team_decision.

  ## Examples

      iex> create_team_decision(%{field: value})
      {:ok, %Team_decision{}}

      iex> create_team_decision(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_decision(attrs \\ %{}) do
    %Team_decision{}
    |> Team_decision.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team_decision.

  ## Examples

      iex> update_team_decision(team_decision, %{field: new_value})
      {:ok, %Team_decision{}}

      iex> update_team_decision(team_decision, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_decision(%Team_decision{} = team_decision, attrs) do
    team_decision
    |> Team_decision.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team_decision.

  ## Examples

      iex> delete_team_decision(team_decision)
      {:ok, %Team_decision{}}

      iex> delete_team_decision(team_decision)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_decision(%Team_decision{} = team_decision) do
    Repo.delete(team_decision)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_decision changes.

  ## Examples

      iex> change_team_decision(team_decision)
      %Ecto.Changeset{data: %Team_decision{}}

  """
  def change_team_decision(%Team_decision{} = team_decision, attrs \\ %{}) do
    Team_decision.changeset(team_decision, attrs)
  end


  def create_team_users(users, team_id) do
    for user_item <- users |> Enum.map(&String.to_integer/1) do
      %Team_user{}
        |> Team_user.changeset(%{"user_id" => user_item, "team_id" => team_id})
        |> Repo.insert()
    end
  end

  def update_team_users(users, team_id) do
    (from su in Team_user, where: su.team_id == ^team_id) |> Repo.delete_all
    for user_item <- users |> Enum.map(&String.to_integer/1) do
      %Team_user{}
        |> Team_user.changeset(%{"user_id" => user_item, "team_id" => team_id})
        |> Repo.insert()
    end
  end

  def get_team_users(id) do
    (Repo.all Ecto.assoc(Repo.get(Team, id), :users))
  end

  def get_user_teams(id) do
    (Repo.all Ecto.assoc(Repo.get(User, id), :teams))
  end

  @doc """
  Returns the list of team_users.

  ## Examples

      iex> list_team_users()
      [%Team_user{}, ...]

  """
  def list_team_users do
    Repo.all(Team_user)
  end

  @doc """
  Gets a single team_user.

  Raises `Ecto.NoResultsError` if the Team user does not exist.

  ## Examples

      iex> get_team_user!(123)
      %Team_user{}

      iex> get_team_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_user!(id), do: Repo.get!(Team_user, id)

  @doc """
  Creates a team_user.

  ## Examples

      iex> create_team_user(%{field: value})
      {:ok, %Team_user{}}

      iex> create_team_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_user(attrs \\ %{}) do
    %Team_user{}
    |> Team_user.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team_user.

  ## Examples

      iex> update_team_user(team_user, %{field: new_value})
      {:ok, %Team_user{}}

      iex> update_team_user(team_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_user(%Team_user{} = team_user, attrs) do
    team_user
    |> Team_user.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team_user.

  ## Examples

      iex> delete_team_user(team_user)
      {:ok, %Team_user{}}

      iex> delete_team_user(team_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_user(%Team_user{} = team_user) do
    Repo.delete(team_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_user changes.

  ## Examples

      iex> change_team_user(team_user)
      %Ecto.Changeset{data: %Team_user{}}

  """
  def change_team_user(%Team_user{} = team_user, attrs \\ %{}) do
    Team_user.changeset(team_user, attrs)
  end
end
