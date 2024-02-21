defmodule HindsightWeb.Team_userControllerTest do
  use HindsightWeb.ConnCase

  import Hindsight.TeamsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all team_users", %{conn: conn} do
      conn = get(conn, Routes.team_user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Team users"
    end
  end

  describe "new team_user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.team_user_path(conn, :new))
      assert html_response(conn, 200) =~ "New Team user"
    end
  end

  describe "create team_user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_user_path(conn, :create), team_user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.team_user_path(conn, :show, id)

      conn = get(conn, Routes.team_user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Team user"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_user_path(conn, :create), team_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Team user"
    end
  end

  describe "edit team_user" do
    setup [:create_team_user]

    test "renders form for editing chosen team_user", %{conn: conn, team_user: team_user} do
      conn = get(conn, Routes.team_user_path(conn, :edit, team_user))
      assert html_response(conn, 200) =~ "Edit Team user"
    end
  end

  describe "update team_user" do
    setup [:create_team_user]

    test "redirects when data is valid", %{conn: conn, team_user: team_user} do
      conn = put(conn, Routes.team_user_path(conn, :update, team_user), team_user: @update_attrs)
      assert redirected_to(conn) == Routes.team_user_path(conn, :show, team_user)

      conn = get(conn, Routes.team_user_path(conn, :show, team_user))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, team_user: team_user} do
      conn = put(conn, Routes.team_user_path(conn, :update, team_user), team_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Team user"
    end
  end

  describe "delete team_user" do
    setup [:create_team_user]

    test "deletes chosen team_user", %{conn: conn, team_user: team_user} do
      conn = delete(conn, Routes.team_user_path(conn, :delete, team_user))
      assert redirected_to(conn) == Routes.team_user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.team_user_path(conn, :show, team_user))
      end
    end
  end

  defp create_team_user(_) do
    team_user = team_user_fixture()
    %{team_user: team_user}
  end
end
