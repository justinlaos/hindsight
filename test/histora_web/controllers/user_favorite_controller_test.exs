defmodule HistoraWeb.User_favoriteControllerTest do
  use HistoraWeb.ConnCase

  import Histora.UsersFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all user_favorites", %{conn: conn} do
      conn = get(conn, Routes.user_favorite_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing User favorites"
    end
  end

  describe "new user_favorite" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_favorite_path(conn, :new))
      assert html_response(conn, 200) =~ "New User favorite"
    end
  end

  describe "create user_favorite" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_favorite_path(conn, :create), user_favorite: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_favorite_path(conn, :show, id)

      conn = get(conn, Routes.user_favorite_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User favorite"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_favorite_path(conn, :create), user_favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User favorite"
    end
  end

  describe "edit user_favorite" do
    setup [:create_user_favorite]

    test "renders form for editing chosen user_favorite", %{conn: conn, user_favorite: user_favorite} do
      conn = get(conn, Routes.user_favorite_path(conn, :edit, user_favorite))
      assert html_response(conn, 200) =~ "Edit User favorite"
    end
  end

  describe "update user_favorite" do
    setup [:create_user_favorite]

    test "redirects when data is valid", %{conn: conn, user_favorite: user_favorite} do
      conn = put(conn, Routes.user_favorite_path(conn, :update, user_favorite), user_favorite: @update_attrs)
      assert redirected_to(conn) == Routes.user_favorite_path(conn, :show, user_favorite)

      conn = get(conn, Routes.user_favorite_path(conn, :show, user_favorite))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user_favorite: user_favorite} do
      conn = put(conn, Routes.user_favorite_path(conn, :update, user_favorite), user_favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User favorite"
    end
  end

  describe "delete user_favorite" do
    setup [:create_user_favorite]

    test "deletes chosen user_favorite", %{conn: conn, user_favorite: user_favorite} do
      conn = delete(conn, Routes.user_favorite_path(conn, :delete, user_favorite))
      assert redirected_to(conn) == Routes.user_favorite_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_favorite_path(conn, :show, user_favorite))
      end
    end
  end

  defp create_user_favorite(_) do
    user_favorite = user_favorite_fixture()
    %{user_favorite: user_favorite}
  end
end
