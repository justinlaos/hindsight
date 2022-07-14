defmodule HistoraWeb.ScopesControllerTest do
  use HistoraWeb.ConnCase

  import Histora.ScopeFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all scopes", %{conn: conn} do
      conn = get(conn, Routes.scopes_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Scopes"
    end
  end

  describe "new scopes" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.scopes_path(conn, :new))
      assert html_response(conn, 200) =~ "New Scopes"
    end
  end

  describe "create scopes" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.scopes_path(conn, :create), scopes: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.scopes_path(conn, :show, id)

      conn = get(conn, Routes.scopes_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Scopes"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.scopes_path(conn, :create), scopes: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Scopes"
    end
  end

  describe "edit scopes" do
    setup [:create_scopes]

    test "renders form for editing chosen scopes", %{conn: conn, scopes: scopes} do
      conn = get(conn, Routes.scopes_path(conn, :edit, scopes))
      assert html_response(conn, 200) =~ "Edit Scopes"
    end
  end

  describe "update scopes" do
    setup [:create_scopes]

    test "redirects when data is valid", %{conn: conn, scopes: scopes} do
      conn = put(conn, Routes.scopes_path(conn, :update, scopes), scopes: @update_attrs)
      assert redirected_to(conn) == Routes.scopes_path(conn, :show, scopes)

      conn = get(conn, Routes.scopes_path(conn, :show, scopes))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, scopes: scopes} do
      conn = put(conn, Routes.scopes_path(conn, :update, scopes), scopes: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Scopes"
    end
  end

  describe "delete scopes" do
    setup [:create_scopes]

    test "deletes chosen scopes", %{conn: conn, scopes: scopes} do
      conn = delete(conn, Routes.scopes_path(conn, :delete, scopes))
      assert redirected_to(conn) == Routes.scopes_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.scopes_path(conn, :show, scopes))
      end
    end
  end

  defp create_scopes(_) do
    scopes = scopes_fixture()
    %{scopes: scopes}
  end
end
