defmodule HistoraWeb.Team_decisionControllerTest do
  use HistoraWeb.ConnCase

  import Histora.TeamsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all team_decisions", %{conn: conn} do
      conn = get(conn, Routes.team_decision_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Team decisions"
    end
  end

  describe "new team_decision" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.team_decision_path(conn, :new))
      assert html_response(conn, 200) =~ "New Team decision"
    end
  end

  describe "create team_decision" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_decision_path(conn, :create), team_decision: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.team_decision_path(conn, :show, id)

      conn = get(conn, Routes.team_decision_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Team decision"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_decision_path(conn, :create), team_decision: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Team decision"
    end
  end

  describe "edit team_decision" do
    setup [:create_team_decision]

    test "renders form for editing chosen team_decision", %{conn: conn, team_decision: team_decision} do
      conn = get(conn, Routes.team_decision_path(conn, :edit, team_decision))
      assert html_response(conn, 200) =~ "Edit Team decision"
    end
  end

  describe "update team_decision" do
    setup [:create_team_decision]

    test "redirects when data is valid", %{conn: conn, team_decision: team_decision} do
      conn = put(conn, Routes.team_decision_path(conn, :update, team_decision), team_decision: @update_attrs)
      assert redirected_to(conn) == Routes.team_decision_path(conn, :show, team_decision)

      conn = get(conn, Routes.team_decision_path(conn, :show, team_decision))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, team_decision: team_decision} do
      conn = put(conn, Routes.team_decision_path(conn, :update, team_decision), team_decision: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Team decision"
    end
  end

  describe "delete team_decision" do
    setup [:create_team_decision]

    test "deletes chosen team_decision", %{conn: conn, team_decision: team_decision} do
      conn = delete(conn, Routes.team_decision_path(conn, :delete, team_decision))
      assert redirected_to(conn) == Routes.team_decision_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.team_decision_path(conn, :show, team_decision))
      end
    end
  end

  defp create_team_decision(_) do
    team_decision = team_decision_fixture()
    %{team_decision: team_decision}
  end
end
