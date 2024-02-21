defmodule HindsightWeb.Decision_userControllerTest do
  use HindsightWeb.ConnCase

  import Hindsight.DecisionsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all decision_users", %{conn: conn} do
      conn = get(conn, Routes.decision_user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Decision users"
    end
  end

  describe "new decision_user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.decision_user_path(conn, :new))
      assert html_response(conn, 200) =~ "New Decision user"
    end
  end

  describe "create decision_user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.decision_user_path(conn, :create), decision_user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.decision_user_path(conn, :show, id)

      conn = get(conn, Routes.decision_user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Decision user"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.decision_user_path(conn, :create), decision_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Decision user"
    end
  end

  describe "edit decision_user" do
    setup [:create_decision_user]

    test "renders form for editing chosen decision_user", %{conn: conn, decision_user: decision_user} do
      conn = get(conn, Routes.decision_user_path(conn, :edit, decision_user))
      assert html_response(conn, 200) =~ "Edit Decision user"
    end
  end

  describe "update decision_user" do
    setup [:create_decision_user]

    test "redirects when data is valid", %{conn: conn, decision_user: decision_user} do
      conn = put(conn, Routes.decision_user_path(conn, :update, decision_user), decision_user: @update_attrs)
      assert redirected_to(conn) == Routes.decision_user_path(conn, :show, decision_user)

      conn = get(conn, Routes.decision_user_path(conn, :show, decision_user))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, decision_user: decision_user} do
      conn = put(conn, Routes.decision_user_path(conn, :update, decision_user), decision_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Decision user"
    end
  end

  describe "delete decision_user" do
    setup [:create_decision_user]

    test "deletes chosen decision_user", %{conn: conn, decision_user: decision_user} do
      conn = delete(conn, Routes.decision_user_path(conn, :delete, decision_user))
      assert redirected_to(conn) == Routes.decision_user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.decision_user_path(conn, :show, decision_user))
      end
    end
  end

  defp create_decision_user(_) do
    decision_user = decision_user_fixture()
    %{decision_user: decision_user}
  end
end
