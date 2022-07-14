defmodule HistoraWeb.ScopeControllerTest do
  use HistoraWeb.ConnCase

  import Histora.ScopesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all scopes", %{conn: conn} do
      conn = get(conn, Routes.scope_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Scopes"
    end
  end

  describe "new scope" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.scope_path(conn, :new))
      assert html_response(conn, 200) =~ "New Scope"
    end
  end

  describe "create scope" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.scope_path(conn, :create), scope: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.scope_path(conn, :show, id)

      conn = get(conn, Routes.scope_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Scope"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.scope_path(conn, :create), scope: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Scope"
    end
  end

  describe "edit scope" do
    setup [:create_scope]

    test "renders form for editing chosen scope", %{conn: conn, scope: scope} do
      conn = get(conn, Routes.scope_path(conn, :edit, scope))
      assert html_response(conn, 200) =~ "Edit Scope"
    end
  end

  describe "update scope" do
    setup [:create_scope]

    test "redirects when data is valid", %{conn: conn, scope: scope} do
      conn = put(conn, Routes.scope_path(conn, :update, scope), scope: @update_attrs)
      assert redirected_to(conn) == Routes.scope_path(conn, :show, scope)

      conn = get(conn, Routes.scope_path(conn, :show, scope))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, scope: scope} do
      conn = put(conn, Routes.scope_path(conn, :update, scope), scope: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Scope"
    end
  end

  describe "delete scope" do
    setup [:create_scope]

    test "deletes chosen scope", %{conn: conn, scope: scope} do
      conn = delete(conn, Routes.scope_path(conn, :delete, scope))
      assert redirected_to(conn) == Routes.scope_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.scope_path(conn, :show, scope))
      end
    end
  end

  defp create_scope(_) do
    scope = scope_fixture()
    %{scope: scope}
  end
end
