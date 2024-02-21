defmodule HindsightWeb.Draft_optionControllerTest do
  use HindsightWeb.ConnCase

  import Hindsight.DraftsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all draft_options", %{conn: conn} do
      conn = get(conn, Routes.draft_option_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Draft options"
    end
  end

  describe "new draft_option" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.draft_option_path(conn, :new))
      assert html_response(conn, 200) =~ "New Draft option"
    end
  end

  describe "create draft_option" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.draft_option_path(conn, :create), draft_option: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.draft_option_path(conn, :show, id)

      conn = get(conn, Routes.draft_option_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Draft option"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.draft_option_path(conn, :create), draft_option: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Draft option"
    end
  end

  describe "edit draft_option" do
    setup [:create_draft_option]

    test "renders form for editing chosen draft_option", %{conn: conn, draft_option: draft_option} do
      conn = get(conn, Routes.draft_option_path(conn, :edit, draft_option))
      assert html_response(conn, 200) =~ "Edit Draft option"
    end
  end

  describe "update draft_option" do
    setup [:create_draft_option]

    test "redirects when data is valid", %{conn: conn, draft_option: draft_option} do
      conn = put(conn, Routes.draft_option_path(conn, :update, draft_option), draft_option: @update_attrs)
      assert redirected_to(conn) == Routes.draft_option_path(conn, :show, draft_option)

      conn = get(conn, Routes.draft_option_path(conn, :show, draft_option))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, draft_option: draft_option} do
      conn = put(conn, Routes.draft_option_path(conn, :update, draft_option), draft_option: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Draft option"
    end
  end

  describe "delete draft_option" do
    setup [:create_draft_option]

    test "deletes chosen draft_option", %{conn: conn, draft_option: draft_option} do
      conn = delete(conn, Routes.draft_option_path(conn, :delete, draft_option))
      assert redirected_to(conn) == Routes.draft_option_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.draft_option_path(conn, :show, draft_option))
      end
    end
  end

  defp create_draft_option(_) do
    draft_option = draft_option_fixture()
    %{draft_option: draft_option}
  end
end
