defmodule Hindsight.TeamTest do
  use Hindsight.DataCase

  alias Hindsight.Team

  describe "teams" do
    alias Hindsight.Team.Teams

    import Hindsight.TeamFixtures

    @invalid_attrs %{}

    test "list_teams/0 returns all teams" do
      teams = teams_fixture()
      assert Team.list_teams() == [teams]
    end

    test "get_teams!/1 returns the teams with given id" do
      teams = teams_fixture()
      assert Team.get_teams!(teams.id) == teams
    end

    test "create_teams/1 with valid data creates a teams" do
      valid_attrs = %{}

      assert {:ok, %Teams{} = teams} = Team.create_teams(valid_attrs)
    end

    test "create_teams/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Team.create_teams(@invalid_attrs)
    end

    test "update_teams/2 with valid data updates the teams" do
      teams = teams_fixture()
      update_attrs = %{}

      assert {:ok, %Teams{} = teams} = Team.update_teams(teams, update_attrs)
    end

    test "update_teams/2 with invalid data returns error changeset" do
      teams = teams_fixture()
      assert {:error, %Ecto.Changeset{}} = Team.update_teams(teams, @invalid_attrs)
      assert teams == Team.get_teams!(teams.id)
    end

    test "delete_teams/1 deletes the teams" do
      teams = teams_fixture()
      assert {:ok, %Teams{}} = Team.delete_teams(teams)
      assert_raise Ecto.NoResultsError, fn -> Team.get_teams!(teams.id) end
    end

    test "change_teams/1 returns a teams changeset" do
      teams = teams_fixture()
      assert %Ecto.Changeset{} = Team.change_teams(teams)
    end
  end
end
