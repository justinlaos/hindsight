defmodule Histora.OrginizationsTest do
  use Histora.DataCase

  alias Histora.Orginizations

  describe "orginizations" do
    alias Histora.Orginizations.Orginization

    import Histora.OrginizationsFixtures

    @invalid_attrs %{}

    test "list_orginizations/0 returns all orginizations" do
      orginization = orginization_fixture()
      assert Orginizations.list_orginizations() == [orginization]
    end

    test "get_orginization!/1 returns the orginization with given id" do
      orginization = orginization_fixture()
      assert Orginizations.get_orginization!(orginization.id) == orginization
    end

    test "create_orginization/1 with valid data creates a orginization" do
      valid_attrs = %{}

      assert {:ok, %Orginization{} = orginization} = Orginizations.create_orginization(valid_attrs)
    end

    test "create_orginization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orginizations.create_orginization(@invalid_attrs)
    end

    test "update_orginization/2 with valid data updates the orginization" do
      orginization = orginization_fixture()
      update_attrs = %{}

      assert {:ok, %Orginization{} = orginization} = Orginizations.update_orginization(orginization, update_attrs)
    end

    test "update_orginization/2 with invalid data returns error changeset" do
      orginization = orginization_fixture()
      assert {:error, %Ecto.Changeset{}} = Orginizations.update_orginization(orginization, @invalid_attrs)
      assert orginization == Orginizations.get_orginization!(orginization.id)
    end

    test "delete_orginization/1 deletes the orginization" do
      orginization = orginization_fixture()
      assert {:ok, %Orginization{}} = Orginizations.delete_orginization(orginization)
      assert_raise Ecto.NoResultsError, fn -> Orginizations.get_orginization!(orginization.id) end
    end

    test "change_orginization/1 returns a orginization changeset" do
      orginization = orginization_fixture()
      assert %Ecto.Changeset{} = Orginizations.change_orginization(orginization)
    end
  end
end
