defmodule HistoraWeb.Draft_teamControllerTest do
  use HistoraWeb.ConnCase

  import Histora.DraftsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all draft_teams", %{conn: conn} do
      conn = get(conn, Routes.draft_team_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Draft teams"
    end
  end

  describe "new draft_team" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.draft_team_path(conn, :new))
      assert html_response(conn, 200) =~ "New Draft team"
    end
  end

  describe "create draft_team" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.draft_team_path(conn, :create), draft_team: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.draft_team_path(conn, :show, id)

      conn = get(conn, Routes.draft_team_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Draft team"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.draft_team_path(conn, :create), draft_team: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Draft team"
    end
  end

  describe "edit draft_team" do
    setup [:create_draft_team]

    test "renders form for editing chosen draft_team", %{conn: conn, draft_team: draft_team} do
      conn = get(conn, Routes.draft_team_path(conn, :edit, draft_team))
      assert html_response(conn, 200) =~ "Edit Draft team"
    end
  end

  describe "update draft_team" do
    setup [:create_draft_team]

    test "redirects when data is valid", %{conn: conn, draft_team: draft_team} do
      conn = put(conn, Routes.draft_team_path(conn, :update, draft_team), draft_team: @update_attrs)
      assert redirected_to(conn) == Routes.draft_team_path(conn, :show, draft_team)

      conn = get(conn, Routes.draft_team_path(conn, :show, draft_team))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, draft_team: draft_team} do
      conn = put(conn, Routes.draft_team_path(conn, :update, draft_team), draft_team: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Draft team"
    end
  end

  describe "delete draft_team" do
    setup [:create_draft_team]

    test "deletes chosen draft_team", %{conn: conn, draft_team: draft_team} do
      conn = delete(conn, Routes.draft_team_path(conn, :delete, draft_team))
      assert redirected_to(conn) == Routes.draft_team_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.draft_team_path(conn, :show, draft_team))
      end
    end
  end

  defp create_draft_team(_) do
    draft_team = draft_team_fixture()
    %{draft_team: draft_team}
  end
end
