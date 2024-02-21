defmodule HindsightWeb.Goal_decisionControllerTest do
  use HindsightWeb.ConnCase

  import Hindsight.GoalsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all tag_decisions", %{conn: conn} do
      conn = get(conn, Routes.tag_decision_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Goal decisions"
    end
  end

  describe "new tag_decision" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tag_decision_path(conn, :new))
      assert html_response(conn, 200) =~ "New Goal decision"
    end
  end

  describe "create tag_decision" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tag_decision_path(conn, :create), tag_decision: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tag_decision_path(conn, :show, id)

      conn = get(conn, Routes.tag_decision_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Goal decision"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tag_decision_path(conn, :create), tag_decision: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Goal decision"
    end
  end

  describe "edit tag_decision" do
    setup [:create_goal_decision]

    test "renders form for editing chosen tag_decision", %{conn: conn, tag_decision: tag_decision} do
      conn = get(conn, Routes.tag_decision_path(conn, :edit, tag_decision))
      assert html_response(conn, 200) =~ "Edit Goal decision"
    end
  end

  describe "update tag_decision" do
    setup [:create_goal_decision]

    test "redirects when data is valid", %{conn: conn, tag_decision: tag_decision} do
      conn = put(conn, Routes.tag_decision_path(conn, :update, tag_decision), tag_decision: @update_attrs)
      assert redirected_to(conn) == Routes.tag_decision_path(conn, :show, tag_decision)

      conn = get(conn, Routes.tag_decision_path(conn, :show, tag_decision))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, tag_decision: tag_decision} do
      conn = put(conn, Routes.tag_decision_path(conn, :update, tag_decision), tag_decision: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Goal decision"
    end
  end

  describe "delete tag_decision" do
    setup [:create_goal_decision]

    test "deletes chosen tag_decision", %{conn: conn, tag_decision: tag_decision} do
      conn = delete(conn, Routes.tag_decision_path(conn, :delete, tag_decision))
      assert redirected_to(conn) == Routes.tag_decision_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.tag_decision_path(conn, :show, tag_decision))
      end
    end
  end

  defp create_goal_decision(_) do
    tag_decision = tag_decision_fixture()
    %{tag_decision: tag_decision}
  end
end
