defmodule HistoraWeb.Tag_favoriteControllerTest do
  use HistoraWeb.ConnCase

  import Histora.TagsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all tag_favorites", %{conn: conn} do
      conn = get(conn, Routes.tag_favorite_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tag favorites"
    end
  end

  describe "new tag_favorite" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tag_favorite_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tag favorite"
    end
  end

  describe "create tag_favorite" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tag_favorite_path(conn, :create), tag_favorite: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tag_favorite_path(conn, :show, id)

      conn = get(conn, Routes.tag_favorite_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tag favorite"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tag_favorite_path(conn, :create), tag_favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tag favorite"
    end
  end

  describe "edit tag_favorite" do
    setup [:create_tag_favorite]

    test "renders form for editing chosen tag_favorite", %{conn: conn, tag_favorite: tag_favorite} do
      conn = get(conn, Routes.tag_favorite_path(conn, :edit, tag_favorite))
      assert html_response(conn, 200) =~ "Edit Tag favorite"
    end
  end

  describe "update tag_favorite" do
    setup [:create_tag_favorite]

    test "redirects when data is valid", %{conn: conn, tag_favorite: tag_favorite} do
      conn = put(conn, Routes.tag_favorite_path(conn, :update, tag_favorite), tag_favorite: @update_attrs)
      assert redirected_to(conn) == Routes.tag_favorite_path(conn, :show, tag_favorite)

      conn = get(conn, Routes.tag_favorite_path(conn, :show, tag_favorite))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, tag_favorite: tag_favorite} do
      conn = put(conn, Routes.tag_favorite_path(conn, :update, tag_favorite), tag_favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tag favorite"
    end
  end

  describe "delete tag_favorite" do
    setup [:create_tag_favorite]

    test "deletes chosen tag_favorite", %{conn: conn, tag_favorite: tag_favorite} do
      conn = delete(conn, Routes.tag_favorite_path(conn, :delete, tag_favorite))
      assert redirected_to(conn) == Routes.tag_favorite_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.tag_favorite_path(conn, :show, tag_favorite))
      end
    end
  end

  defp create_tag_favorite(_) do
    tag_favorite = tag_favorite_fixture()
    %{tag_favorite: tag_favorite}
  end
end
