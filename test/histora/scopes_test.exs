defmodule Histora.ScopesTest do
  use Histora.DataCase

  alias Histora.Scopes

  describe "scopes" do
    alias Histora.Scopes.Scope

    import Histora.ScopesFixtures

    @invalid_attrs %{}

    test "list_scopes/0 returns all scopes" do
      scope = scope_fixture()
      assert Scopes.list_scopes() == [scope]
    end

    test "get_scope!/1 returns the scope with given id" do
      scope = scope_fixture()
      assert Scopes.get_scope!(scope.id) == scope
    end

    test "create_scope/1 with valid data creates a scope" do
      valid_attrs = %{}

      assert {:ok, %Scope{} = scope} = Scopes.create_scope(valid_attrs)
    end

    test "create_scope/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scopes.create_scope(@invalid_attrs)
    end

    test "update_scope/2 with valid data updates the scope" do
      scope = scope_fixture()
      update_attrs = %{}

      assert {:ok, %Scope{} = scope} = Scopes.update_scope(scope, update_attrs)
    end

    test "update_scope/2 with invalid data returns error changeset" do
      scope = scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Scopes.update_scope(scope, @invalid_attrs)
      assert scope == Scopes.get_scope!(scope.id)
    end

    test "delete_scope/1 deletes the scope" do
      scope = scope_fixture()
      assert {:ok, %Scope{}} = Scopes.delete_scope(scope)
      assert_raise Ecto.NoResultsError, fn -> Scopes.get_scope!(scope.id) end
    end

    test "change_scope/1 returns a scope changeset" do
      scope = scope_fixture()
      assert %Ecto.Changeset{} = Scopes.change_scope(scope)
    end
  end

  describe "scope_decisions" do
    alias Histora.Scopes.Scope_decision

    import Histora.ScopesFixtures

    @invalid_attrs %{}

    test "list_scope_decisions/0 returns all scope_decisions" do
      scope_decision = scope_decision_fixture()
      assert Scopes.list_scope_decisions() == [scope_decision]
    end

    test "get_scope_decision!/1 returns the scope_decision with given id" do
      scope_decision = scope_decision_fixture()
      assert Scopes.get_scope_decision!(scope_decision.id) == scope_decision
    end

    test "create_scope_decision/1 with valid data creates a scope_decision" do
      valid_attrs = %{}

      assert {:ok, %Scope_decision{} = scope_decision} = Scopes.create_scope_decision(valid_attrs)
    end

    test "create_scope_decision/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scopes.create_scope_decision(@invalid_attrs)
    end

    test "update_scope_decision/2 with valid data updates the scope_decision" do
      scope_decision = scope_decision_fixture()
      update_attrs = %{}

      assert {:ok, %Scope_decision{} = scope_decision} = Scopes.update_scope_decision(scope_decision, update_attrs)
    end

    test "update_scope_decision/2 with invalid data returns error changeset" do
      scope_decision = scope_decision_fixture()
      assert {:error, %Ecto.Changeset{}} = Scopes.update_scope_decision(scope_decision, @invalid_attrs)
      assert scope_decision == Scopes.get_scope_decision!(scope_decision.id)
    end

    test "delete_scope_decision/1 deletes the scope_decision" do
      scope_decision = scope_decision_fixture()
      assert {:ok, %Scope_decision{}} = Scopes.delete_scope_decision(scope_decision)
      assert_raise Ecto.NoResultsError, fn -> Scopes.get_scope_decision!(scope_decision.id) end
    end

    test "change_scope_decision/1 returns a scope_decision changeset" do
      scope_decision = scope_decision_fixture()
      assert %Ecto.Changeset{} = Scopes.change_scope_decision(scope_decision)
    end
  end

  describe "scope_users" do
    alias Histora.Scopes.Scope_user

    import Histora.ScopesFixtures

    @invalid_attrs %{}

    test "list_scope_users/0 returns all scope_users" do
      scope_user = scope_user_fixture()
      assert Scopes.list_scope_users() == [scope_user]
    end

    test "get_scope_user!/1 returns the scope_user with given id" do
      scope_user = scope_user_fixture()
      assert Scopes.get_scope_user!(scope_user.id) == scope_user
    end

    test "create_scope_user/1 with valid data creates a scope_user" do
      valid_attrs = %{}

      assert {:ok, %Scope_user{} = scope_user} = Scopes.create_scope_user(valid_attrs)
    end

    test "create_scope_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scopes.create_scope_user(@invalid_attrs)
    end

    test "update_scope_user/2 with valid data updates the scope_user" do
      scope_user = scope_user_fixture()
      update_attrs = %{}

      assert {:ok, %Scope_user{} = scope_user} = Scopes.update_scope_user(scope_user, update_attrs)
    end

    test "update_scope_user/2 with invalid data returns error changeset" do
      scope_user = scope_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Scopes.update_scope_user(scope_user, @invalid_attrs)
      assert scope_user == Scopes.get_scope_user!(scope_user.id)
    end

    test "delete_scope_user/1 deletes the scope_user" do
      scope_user = scope_user_fixture()
      assert {:ok, %Scope_user{}} = Scopes.delete_scope_user(scope_user)
      assert_raise Ecto.NoResultsError, fn -> Scopes.get_scope_user!(scope_user.id) end
    end

    test "change_scope_user/1 returns a scope_user changeset" do
      scope_user = scope_user_fixture()
      assert %Ecto.Changeset{} = Scopes.change_scope_user(scope_user)
    end
  end
end
