defmodule Hindsight.DecisionsTest do
  use Hindsight.DataCase

  alias Hindsight.Decisions

  describe "decisions" do
    alias Hindsight.Decisions.Decision

    import Hindsight.DecisionsFixtures

    @invalid_attrs %{}

    test "list_decisions/0 returns all decisions" do
      decision = decision_fixture()
      assert Decisions.list_decisions() == [decision]
    end

    test "get_decision!/1 returns the decision with given id" do
      decision = decision_fixture()
      assert Decisions.get_decision!(decision.id) == decision
    end

    test "create_decision/1 with valid data creates a decision" do
      valid_attrs = %{}

      assert {:ok, %Decision{} = decision} = Decisions.create_decision(valid_attrs)
    end

    test "create_decision/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Decisions.create_decision(@invalid_attrs)
    end

    test "update_decision/2 with valid data updates the decision" do
      decision = decision_fixture()
      update_attrs = %{}

      assert {:ok, %Decision{} = decision} = Decisions.update_decision(decision, update_attrs)
    end

    test "update_decision/2 with invalid data returns error changeset" do
      decision = decision_fixture()
      assert {:error, %Ecto.Changeset{}} = Decisions.update_decision(decision, @invalid_attrs)
      assert decision == Decisions.get_decision!(decision.id)
    end

    test "delete_decision/1 deletes the decision" do
      decision = decision_fixture()
      assert {:ok, %Decision{}} = Decisions.delete_decision(decision)
      assert_raise Ecto.NoResultsError, fn -> Decisions.get_decision!(decision.id) end
    end

    test "change_decision/1 returns a decision changeset" do
      decision = decision_fixture()
      assert %Ecto.Changeset{} = Decisions.change_decision(decision)
    end
  end

  describe "decision_users" do
    alias Hindsight.Decisions.Decision_user

    import Hindsight.DecisionsFixtures

    @invalid_attrs %{}

    test "list_decision_users/0 returns all decision_users" do
      decision_user = decision_user_fixture()
      assert Decisions.list_decision_users() == [decision_user]
    end

    test "get_decision_user!/1 returns the decision_user with given id" do
      decision_user = decision_user_fixture()
      assert Decisions.get_decision_user!(decision_user.id) == decision_user
    end

    test "create_decision_user/1 with valid data creates a decision_user" do
      valid_attrs = %{}

      assert {:ok, %Decision_user{} = decision_user} = Decisions.create_decision_user(valid_attrs)
    end

    test "create_decision_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Decisions.create_decision_user(@invalid_attrs)
    end

    test "update_decision_user/2 with valid data updates the decision_user" do
      decision_user = decision_user_fixture()
      update_attrs = %{}

      assert {:ok, %Decision_user{} = decision_user} = Decisions.update_decision_user(decision_user, update_attrs)
    end

    test "update_decision_user/2 with invalid data returns error changeset" do
      decision_user = decision_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Decisions.update_decision_user(decision_user, @invalid_attrs)
      assert decision_user == Decisions.get_decision_user!(decision_user.id)
    end

    test "delete_decision_user/1 deletes the decision_user" do
      decision_user = decision_user_fixture()
      assert {:ok, %Decision_user{}} = Decisions.delete_decision_user(decision_user)
      assert_raise Ecto.NoResultsError, fn -> Decisions.get_decision_user!(decision_user.id) end
    end

    test "change_decision_user/1 returns a decision_user changeset" do
      decision_user = decision_user_fixture()
      assert %Ecto.Changeset{} = Decisions.change_decision_user(decision_user)
    end
  end
end
