defmodule Histora.TeamsTest do
  use Histora.DataCase

  alias Histora.Teams

  describe "teams" do
    alias Histora.Teams.Team

    import Histora.TeamsFixtures

    @invalid_attrs %{}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end

  describe "team_decisions" do
    alias Histora.Teams.Team_decision

    import Histora.TeamsFixtures

    @invalid_attrs %{}

    test "list_team_decisions/0 returns all team_decisions" do
      team_decision = team_decision_fixture()
      assert Teams.list_team_decisions() == [team_decision]
    end

    test "get_team_decision!/1 returns the team_decision with given id" do
      team_decision = team_decision_fixture()
      assert Teams.get_team_decision!(team_decision.id) == team_decision
    end

    test "create_team_decision/1 with valid data creates a team_decision" do
      valid_attrs = %{}

      assert {:ok, %Team_decision{} = team_decision} = Teams.create_team_decision(valid_attrs)
    end

    test "create_team_decision/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team_decision(@invalid_attrs)
    end

    test "update_team_decision/2 with valid data updates the team_decision" do
      team_decision = team_decision_fixture()
      update_attrs = %{}

      assert {:ok, %Team_decision{} = team_decision} = Teams.update_team_decision(team_decision, update_attrs)
    end

    test "update_team_decision/2 with invalid data returns error changeset" do
      team_decision = team_decision_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team_decision(team_decision, @invalid_attrs)
      assert team_decision == Teams.get_team_decision!(team_decision.id)
    end

    test "delete_team_decision/1 deletes the team_decision" do
      team_decision = team_decision_fixture()
      assert {:ok, %Team_decision{}} = Teams.delete_team_decision(team_decision)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team_decision!(team_decision.id) end
    end

    test "change_team_decision/1 returns a team_decision changeset" do
      team_decision = team_decision_fixture()
      assert %Ecto.Changeset{} = Teams.change_team_decision(team_decision)
    end
  end

  describe "team_users" do
    alias Histora.Teams.Team_user

    import Histora.TeamsFixtures

    @invalid_attrs %{}

    test "list_team_users/0 returns all team_users" do
      team_user = team_user_fixture()
      assert Teams.list_team_users() == [team_user]
    end

    test "get_team_user!/1 returns the team_user with given id" do
      team_user = team_user_fixture()
      assert Teams.get_team_user!(team_user.id) == team_user
    end

    test "create_team_user/1 with valid data creates a team_user" do
      valid_attrs = %{}

      assert {:ok, %Team_user{} = team_user} = Teams.create_team_user(valid_attrs)
    end

    test "create_team_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team_user(@invalid_attrs)
    end

    test "update_team_user/2 with valid data updates the team_user" do
      team_user = team_user_fixture()
      update_attrs = %{}

      assert {:ok, %Team_user{} = team_user} = Teams.update_team_user(team_user, update_attrs)
    end

    test "update_team_user/2 with invalid data returns error changeset" do
      team_user = team_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team_user(team_user, @invalid_attrs)
      assert team_user == Teams.get_team_user!(team_user.id)
    end

    test "delete_team_user/1 deletes the team_user" do
      team_user = team_user_fixture()
      assert {:ok, %Team_user{}} = Teams.delete_team_user(team_user)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team_user!(team_user.id) end
    end

    test "change_team_user/1 returns a team_user changeset" do
      team_user = team_user_fixture()
      assert %Ecto.Changeset{} = Teams.change_team_user(team_user)
    end
  end
end
