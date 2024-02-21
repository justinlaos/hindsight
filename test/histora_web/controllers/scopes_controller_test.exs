defmodule HindsightWeb.TeamsControllerTest do
  use HindsightWeb.ConnCase

  import Hindsight.TeamFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all teams", %{conn: conn} do
      conn = get(conn, Routes.teams_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Teams"
    end
  end

  describe "new teams" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.teams_path(conn, :new))
      assert html_response(conn, 200) =~ "New Teams"
    end
  end

  describe "create teams" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.teams_path(conn, :create), teams: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.teams_path(conn, :show, id)

      conn = get(conn, Routes.teams_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Teams"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.teams_path(conn, :create), teams: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Teams"
    end
  end

  describe "edit teams" do
    setup [:create_teams]

    test "renders form for editing chosen teams", %{conn: conn, teams: teams} do
      conn = get(conn, Routes.teams_path(conn, :edit, teams))
      assert html_response(conn, 200) =~ "Edit Teams"
    end
  end

  describe "update teams" do
    setup [:create_teams]

    test "redirects when data is valid", %{conn: conn, teams: teams} do
      conn = put(conn, Routes.teams_path(conn, :update, teams), teams: @update_attrs)
      assert redirected_to(conn) == Routes.teams_path(conn, :show, teams)

      conn = get(conn, Routes.teams_path(conn, :show, teams))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, teams: teams} do
      conn = put(conn, Routes.teams_path(conn, :update, teams), teams: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Teams"
    end
  end

  describe "delete teams" do
    setup [:create_teams]

    test "deletes chosen teams", %{conn: conn, teams: teams} do
      conn = delete(conn, Routes.teams_path(conn, :delete, teams))
      assert redirected_to(conn) == Routes.teams_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.teams_path(conn, :show, teams))
      end
    end
  end

  defp create_teams(_) do
    teams = teams_fixture()
    %{teams: teams}
  end
end
