defmodule Histora.ReflectionsTest do
  use Histora.DataCase

  alias Histora.Reflections

  describe "reflections" do
    alias Histora.Reflections.Reflection

    import Histora.ReflectionsFixtures

    @invalid_attrs %{}

    test "list_reflections/0 returns all reflections" do
      reflection = reflection_fixture()
      assert Reflections.list_reflections() == [reflection]
    end

    test "get_reflection!/1 returns the reflection with given id" do
      reflection = reflection_fixture()
      assert Reflections.get_reflection!(reflection.id) == reflection
    end

    test "create_reflection/1 with valid data creates a reflection" do
      valid_attrs = %{}

      assert {:ok, %Reflection{} = reflection} = Reflections.create_reflection(valid_attrs)
    end

    test "create_reflection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reflections.create_reflection(@invalid_attrs)
    end

    test "update_reflection/2 with valid data updates the reflection" do
      reflection = reflection_fixture()
      update_attrs = %{}

      assert {:ok, %Reflection{} = reflection} = Reflections.update_reflection(reflection, update_attrs)
    end

    test "update_reflection/2 with invalid data returns error changeset" do
      reflection = reflection_fixture()
      assert {:error, %Ecto.Changeset{}} = Reflections.update_reflection(reflection, @invalid_attrs)
      assert reflection == Reflections.get_reflection!(reflection.id)
    end

    test "delete_reflection/1 deletes the reflection" do
      reflection = reflection_fixture()
      assert {:ok, %Reflection{}} = Reflections.delete_reflection(reflection)
      assert_raise Ecto.NoResultsError, fn -> Reflections.get_reflection!(reflection.id) end
    end

    test "change_reflection/1 returns a reflection changeset" do
      reflection = reflection_fixture()
      assert %Ecto.Changeset{} = Reflections.change_reflection(reflection)
    end
  end
end
