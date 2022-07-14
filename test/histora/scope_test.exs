defmodule Histora.ScopeTest do
  use Histora.DataCase

  alias Histora.Scope

  describe "scopes" do
    alias Histora.Scope.Scopes

    import Histora.ScopeFixtures

    @invalid_attrs %{}

    test "list_scopes/0 returns all scopes" do
      scopes = scopes_fixture()
      assert Scope.list_scopes() == [scopes]
    end

    test "get_scopes!/1 returns the scopes with given id" do
      scopes = scopes_fixture()
      assert Scope.get_scopes!(scopes.id) == scopes
    end

    test "create_scopes/1 with valid data creates a scopes" do
      valid_attrs = %{}

      assert {:ok, %Scopes{} = scopes} = Scope.create_scopes(valid_attrs)
    end

    test "create_scopes/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scope.create_scopes(@invalid_attrs)
    end

    test "update_scopes/2 with valid data updates the scopes" do
      scopes = scopes_fixture()
      update_attrs = %{}

      assert {:ok, %Scopes{} = scopes} = Scope.update_scopes(scopes, update_attrs)
    end

    test "update_scopes/2 with invalid data returns error changeset" do
      scopes = scopes_fixture()
      assert {:error, %Ecto.Changeset{}} = Scope.update_scopes(scopes, @invalid_attrs)
      assert scopes == Scope.get_scopes!(scopes.id)
    end

    test "delete_scopes/1 deletes the scopes" do
      scopes = scopes_fixture()
      assert {:ok, %Scopes{}} = Scope.delete_scopes(scopes)
      assert_raise Ecto.NoResultsError, fn -> Scope.get_scopes!(scopes.id) end
    end

    test "change_scopes/1 returns a scopes changeset" do
      scopes = scopes_fixture()
      assert %Ecto.Changeset{} = Scope.change_scopes(scopes)
    end
  end
end
