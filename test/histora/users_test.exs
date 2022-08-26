defmodule Histora.UsersTest do
  use Histora.DataCase

  alias Histora.Users

  describe "user_favorites" do
    alias Histora.Users.User_favorite

    import Histora.UsersFixtures

    @invalid_attrs %{}

    test "list_user_favorites/0 returns all user_favorites" do
      user_favorite = user_favorite_fixture()
      assert Users.list_user_favorites() == [user_favorite]
    end

    test "get_user_favorite!/1 returns the user_favorite with given id" do
      user_favorite = user_favorite_fixture()
      assert Users.get_user_favorite!(user_favorite.id) == user_favorite
    end

    test "create_user_favorite/1 with valid data creates a user_favorite" do
      valid_attrs = %{}

      assert {:ok, %User_favorite{} = user_favorite} = Users.create_user_favorite(valid_attrs)
    end

    test "create_user_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user_favorite(@invalid_attrs)
    end

    test "update_user_favorite/2 with valid data updates the user_favorite" do
      user_favorite = user_favorite_fixture()
      update_attrs = %{}

      assert {:ok, %User_favorite{} = user_favorite} = Users.update_user_favorite(user_favorite, update_attrs)
    end

    test "update_user_favorite/2 with invalid data returns error changeset" do
      user_favorite = user_favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user_favorite(user_favorite, @invalid_attrs)
      assert user_favorite == Users.get_user_favorite!(user_favorite.id)
    end

    test "delete_user_favorite/1 deletes the user_favorite" do
      user_favorite = user_favorite_fixture()
      assert {:ok, %User_favorite{}} = Users.delete_user_favorite(user_favorite)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user_favorite!(user_favorite.id) end
    end

    test "change_user_favorite/1 returns a user_favorite changeset" do
      user_favorite = user_favorite_fixture()
      assert %Ecto.Changeset{} = Users.change_user_favorite(user_favorite)
    end
  end

  describe "user_data" do
    alias Histora.Users.User_data

    import Histora.UsersFixtures

    @invalid_attrs %{}

    test "list_user_data/0 returns all user_data" do
      user_data = user_data_fixture()
      assert Users.list_user_data() == [user_data]
    end

    test "get_user_data!/1 returns the user_data with given id" do
      user_data = user_data_fixture()
      assert Users.get_user_data!(user_data.id) == user_data
    end

    test "create_user_data/1 with valid data creates a user_data" do
      valid_attrs = %{}

      assert {:ok, %User_data{} = user_data} = Users.create_user_data(valid_attrs)
    end

    test "create_user_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user_data(@invalid_attrs)
    end

    test "update_user_data/2 with valid data updates the user_data" do
      user_data = user_data_fixture()
      update_attrs = %{}

      assert {:ok, %User_data{} = user_data} = Users.update_user_data(user_data, update_attrs)
    end

    test "update_user_data/2 with invalid data returns error changeset" do
      user_data = user_data_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user_data(user_data, @invalid_attrs)
      assert user_data == Users.get_user_data!(user_data.id)
    end

    test "delete_user_data/1 deletes the user_data" do
      user_data = user_data_fixture()
      assert {:ok, %User_data{}} = Users.delete_user_data(user_data)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user_data!(user_data.id) end
    end

    test "change_user_data/1 returns a user_data changeset" do
      user_data = user_data_fixture()
      assert %Ecto.Changeset{} = Users.change_user_data(user_data)
    end
  end
end
