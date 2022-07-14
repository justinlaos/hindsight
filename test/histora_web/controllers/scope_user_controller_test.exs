defmodule HistoraWeb.Scope_userControllerTest do
  use HistoraWeb.ConnCase

  import Histora.ScopesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all scope_users", %{conn: conn} do
      conn = get(conn, Routes.scope_user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Scope users"
    end
  end

  describe "new scope_user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.scope_user_path(conn, :new))
      assert html_response(conn, 200) =~ "New Scope user"
    end
  end

  describe "create scope_user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.scope_user_path(conn, :create), scope_user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.scope_user_path(conn, :show, id)

      conn = get(conn, Routes.scope_user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Scope user"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.scope_user_path(conn, :create), scope_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Scope user"
    end
  end

  describe "edit scope_user" do
    setup [:create_scope_user]

    test "renders form for editing chosen scope_user", %{conn: conn, scope_user: scope_user} do
      conn = get(conn, Routes.scope_user_path(conn, :edit, scope_user))
      assert html_response(conn, 200) =~ "Edit Scope user"
    end
  end

  describe "update scope_user" do
    setup [:create_scope_user]

    test "redirects when data is valid", %{conn: conn, scope_user: scope_user} do
      conn = put(conn, Routes.scope_user_path(conn, :update, scope_user), scope_user: @update_attrs)
      assert redirected_to(conn) == Routes.scope_user_path(conn, :show, scope_user)

      conn = get(conn, Routes.scope_user_path(conn, :show, scope_user))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, scope_user: scope_user} do
      conn = put(conn, Routes.scope_user_path(conn, :update, scope_user), scope_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Scope user"
    end
  end

  describe "delete scope_user" do
    setup [:create_scope_user]

    test "deletes chosen scope_user", %{conn: conn, scope_user: scope_user} do
      conn = delete(conn, Routes.scope_user_path(conn, :delete, scope_user))
      assert redirected_to(conn) == Routes.scope_user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.scope_user_path(conn, :show, scope_user))
      end
    end
  end

  defp create_scope_user(_) do
    scope_user = scope_user_fixture()
    %{scope_user: scope_user}
  end
end
