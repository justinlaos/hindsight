defmodule HistoraWeb.Scope_decisionControllerTest do
  use HistoraWeb.ConnCase

  import Histora.ScopesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all scope_decisions", %{conn: conn} do
      conn = get(conn, Routes.scope_decision_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Scope decisions"
    end
  end

  describe "new scope_decision" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.scope_decision_path(conn, :new))
      assert html_response(conn, 200) =~ "New Scope decision"
    end
  end

  describe "create scope_decision" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.scope_decision_path(conn, :create), scope_decision: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.scope_decision_path(conn, :show, id)

      conn = get(conn, Routes.scope_decision_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Scope decision"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.scope_decision_path(conn, :create), scope_decision: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Scope decision"
    end
  end

  describe "edit scope_decision" do
    setup [:create_scope_decision]

    test "renders form for editing chosen scope_decision", %{conn: conn, scope_decision: scope_decision} do
      conn = get(conn, Routes.scope_decision_path(conn, :edit, scope_decision))
      assert html_response(conn, 200) =~ "Edit Scope decision"
    end
  end

  describe "update scope_decision" do
    setup [:create_scope_decision]

    test "redirects when data is valid", %{conn: conn, scope_decision: scope_decision} do
      conn = put(conn, Routes.scope_decision_path(conn, :update, scope_decision), scope_decision: @update_attrs)
      assert redirected_to(conn) == Routes.scope_decision_path(conn, :show, scope_decision)

      conn = get(conn, Routes.scope_decision_path(conn, :show, scope_decision))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, scope_decision: scope_decision} do
      conn = put(conn, Routes.scope_decision_path(conn, :update, scope_decision), scope_decision: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Scope decision"
    end
  end

  describe "delete scope_decision" do
    setup [:create_scope_decision]

    test "deletes chosen scope_decision", %{conn: conn, scope_decision: scope_decision} do
      conn = delete(conn, Routes.scope_decision_path(conn, :delete, scope_decision))
      assert redirected_to(conn) == Routes.scope_decision_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.scope_decision_path(conn, :show, scope_decision))
      end
    end
  end

  defp create_scope_decision(_) do
    scope_decision = scope_decision_fixture()
    %{scope_decision: scope_decision}
  end
end
