defmodule HistoraWeb.Draft_scopeControllerTest do
  use HistoraWeb.ConnCase

  import Histora.DraftsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all draft_scopes", %{conn: conn} do
      conn = get(conn, Routes.draft_scope_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Draft scopes"
    end
  end

  describe "new draft_scope" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.draft_scope_path(conn, :new))
      assert html_response(conn, 200) =~ "New Draft scope"
    end
  end

  describe "create draft_scope" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.draft_scope_path(conn, :create), draft_scope: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.draft_scope_path(conn, :show, id)

      conn = get(conn, Routes.draft_scope_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Draft scope"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.draft_scope_path(conn, :create), draft_scope: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Draft scope"
    end
  end

  describe "edit draft_scope" do
    setup [:create_draft_scope]

    test "renders form for editing chosen draft_scope", %{conn: conn, draft_scope: draft_scope} do
      conn = get(conn, Routes.draft_scope_path(conn, :edit, draft_scope))
      assert html_response(conn, 200) =~ "Edit Draft scope"
    end
  end

  describe "update draft_scope" do
    setup [:create_draft_scope]

    test "redirects when data is valid", %{conn: conn, draft_scope: draft_scope} do
      conn = put(conn, Routes.draft_scope_path(conn, :update, draft_scope), draft_scope: @update_attrs)
      assert redirected_to(conn) == Routes.draft_scope_path(conn, :show, draft_scope)

      conn = get(conn, Routes.draft_scope_path(conn, :show, draft_scope))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, draft_scope: draft_scope} do
      conn = put(conn, Routes.draft_scope_path(conn, :update, draft_scope), draft_scope: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Draft scope"
    end
  end

  describe "delete draft_scope" do
    setup [:create_draft_scope]

    test "deletes chosen draft_scope", %{conn: conn, draft_scope: draft_scope} do
      conn = delete(conn, Routes.draft_scope_path(conn, :delete, draft_scope))
      assert redirected_to(conn) == Routes.draft_scope_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.draft_scope_path(conn, :show, draft_scope))
      end
    end
  end

  defp create_draft_scope(_) do
    draft_scope = draft_scope_fixture()
    %{draft_scope: draft_scope}
  end
end
