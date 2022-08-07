defmodule HistoraWeb.Draft_userControllerTest do
  use HistoraWeb.ConnCase

  import Histora.DraftsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all draft_users", %{conn: conn} do
      conn = get(conn, Routes.draft_user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Draft users"
    end
  end

  describe "new draft_user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.draft_user_path(conn, :new))
      assert html_response(conn, 200) =~ "New Draft user"
    end
  end

  describe "create draft_user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.draft_user_path(conn, :create), draft_user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.draft_user_path(conn, :show, id)

      conn = get(conn, Routes.draft_user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Draft user"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.draft_user_path(conn, :create), draft_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Draft user"
    end
  end

  describe "edit draft_user" do
    setup [:create_draft_user]

    test "renders form for editing chosen draft_user", %{conn: conn, draft_user: draft_user} do
      conn = get(conn, Routes.draft_user_path(conn, :edit, draft_user))
      assert html_response(conn, 200) =~ "Edit Draft user"
    end
  end

  describe "update draft_user" do
    setup [:create_draft_user]

    test "redirects when data is valid", %{conn: conn, draft_user: draft_user} do
      conn = put(conn, Routes.draft_user_path(conn, :update, draft_user), draft_user: @update_attrs)
      assert redirected_to(conn) == Routes.draft_user_path(conn, :show, draft_user)

      conn = get(conn, Routes.draft_user_path(conn, :show, draft_user))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, draft_user: draft_user} do
      conn = put(conn, Routes.draft_user_path(conn, :update, draft_user), draft_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Draft user"
    end
  end

  describe "delete draft_user" do
    setup [:create_draft_user]

    test "deletes chosen draft_user", %{conn: conn, draft_user: draft_user} do
      conn = delete(conn, Routes.draft_user_path(conn, :delete, draft_user))
      assert redirected_to(conn) == Routes.draft_user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.draft_user_path(conn, :show, draft_user))
      end
    end
  end

  defp create_draft_user(_) do
    draft_user = draft_user_fixture()
    %{draft_user: draft_user}
  end
end
