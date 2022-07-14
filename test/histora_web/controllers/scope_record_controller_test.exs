defmodule HistoraWeb.Scope_recordControllerTest do
  use HistoraWeb.ConnCase

  import Histora.ScopesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all scope_records", %{conn: conn} do
      conn = get(conn, Routes.scope_record_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Scope records"
    end
  end

  describe "new scope_record" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.scope_record_path(conn, :new))
      assert html_response(conn, 200) =~ "New Scope record"
    end
  end

  describe "create scope_record" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.scope_record_path(conn, :create), scope_record: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.scope_record_path(conn, :show, id)

      conn = get(conn, Routes.scope_record_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Scope record"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.scope_record_path(conn, :create), scope_record: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Scope record"
    end
  end

  describe "edit scope_record" do
    setup [:create_scope_record]

    test "renders form for editing chosen scope_record", %{conn: conn, scope_record: scope_record} do
      conn = get(conn, Routes.scope_record_path(conn, :edit, scope_record))
      assert html_response(conn, 200) =~ "Edit Scope record"
    end
  end

  describe "update scope_record" do
    setup [:create_scope_record]

    test "redirects when data is valid", %{conn: conn, scope_record: scope_record} do
      conn = put(conn, Routes.scope_record_path(conn, :update, scope_record), scope_record: @update_attrs)
      assert redirected_to(conn) == Routes.scope_record_path(conn, :show, scope_record)

      conn = get(conn, Routes.scope_record_path(conn, :show, scope_record))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, scope_record: scope_record} do
      conn = put(conn, Routes.scope_record_path(conn, :update, scope_record), scope_record: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Scope record"
    end
  end

  describe "delete scope_record" do
    setup [:create_scope_record]

    test "deletes chosen scope_record", %{conn: conn, scope_record: scope_record} do
      conn = delete(conn, Routes.scope_record_path(conn, :delete, scope_record))
      assert redirected_to(conn) == Routes.scope_record_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.scope_record_path(conn, :show, scope_record))
      end
    end
  end

  defp create_scope_record(_) do
    scope_record = scope_record_fixture()
    %{scope_record: scope_record}
  end
end
