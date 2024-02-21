defmodule HindsightWeb.DecisionControllerTest do
  use HindsightWeb.ConnCase

  import Hindsight.DecisionsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all decisions", %{conn: conn} do
      conn = get(conn, Routes.decision_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Decisions"
    end
  end

  describe "new decision" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.decision_path(conn, :new))
      assert html_response(conn, 200) =~ "New Decision"
    end
  end

  describe "create decision" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.decision_path(conn, :create), decision: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.decision_path(conn, :show, id)

      conn = get(conn, Routes.decision_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Decision"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.decision_path(conn, :create), decision: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Decision"
    end
  end

  describe "edit decision" do
    setup [:create_decision]

    test "renders form for editing chosen decision", %{conn: conn, decision: decision} do
      conn = get(conn, Routes.decision_path(conn, :edit, decision))
      assert html_response(conn, 200) =~ "Edit Decision"
    end
  end

  describe "update decision" do
    setup [:create_decision]

    test "redirects when data is valid", %{conn: conn, decision: decision} do
      conn = put(conn, Routes.decision_path(conn, :update, decision), decision: @update_attrs)
      assert redirected_to(conn) == Routes.decision_path(conn, :show, decision)

      conn = get(conn, Routes.decision_path(conn, :show, decision))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, decision: decision} do
      conn = put(conn, Routes.decision_path(conn, :update, decision), decision: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Decision"
    end
  end

  describe "delete decision" do
    setup [:create_decision]

    test "deletes chosen decision", %{conn: conn, decision: decision} do
      conn = delete(conn, Routes.decision_path(conn, :delete, decision))
      assert redirected_to(conn) == Routes.decision_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.decision_path(conn, :show, decision))
      end
    end
  end

  defp create_decision(_) do
    decision = decision_fixture()
    %{decision: decision}
  end
end
