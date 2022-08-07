defmodule HistoraWeb.DraftControllerTest do
  use HistoraWeb.ConnCase

  import Histora.DraftsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all drafts", %{conn: conn} do
      conn = get(conn, Routes.draft_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Drafts"
    end
  end

  describe "new draft" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.draft_path(conn, :new))
      assert html_response(conn, 200) =~ "New Draft"
    end
  end

  describe "create draft" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.draft_path(conn, :create), draft: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.draft_path(conn, :show, id)

      conn = get(conn, Routes.draft_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Draft"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.draft_path(conn, :create), draft: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Draft"
    end
  end

  describe "edit draft" do
    setup [:create_draft]

    test "renders form for editing chosen draft", %{conn: conn, draft: draft} do
      conn = get(conn, Routes.draft_path(conn, :edit, draft))
      assert html_response(conn, 200) =~ "Edit Draft"
    end
  end

  describe "update draft" do
    setup [:create_draft]

    test "redirects when data is valid", %{conn: conn, draft: draft} do
      conn = put(conn, Routes.draft_path(conn, :update, draft), draft: @update_attrs)
      assert redirected_to(conn) == Routes.draft_path(conn, :show, draft)

      conn = get(conn, Routes.draft_path(conn, :show, draft))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, draft: draft} do
      conn = put(conn, Routes.draft_path(conn, :update, draft), draft: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Draft"
    end
  end

  describe "delete draft" do
    setup [:create_draft]

    test "deletes chosen draft", %{conn: conn, draft: draft} do
      conn = delete(conn, Routes.draft_path(conn, :delete, draft))
      assert redirected_to(conn) == Routes.draft_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.draft_path(conn, :show, draft))
      end
    end
  end

  defp create_draft(_) do
    draft = draft_fixture()
    %{draft: draft}
  end
end
