defmodule HistoraWeb.Draft_voteControllerTest do
  use HistoraWeb.ConnCase

  import Histora.DraftsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all draft_votes", %{conn: conn} do
      conn = get(conn, Routes.draft_vote_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Draft votes"
    end
  end

  describe "new draft_vote" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.draft_vote_path(conn, :new))
      assert html_response(conn, 200) =~ "New Draft vote"
    end
  end

  describe "create draft_vote" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.draft_vote_path(conn, :create), draft_vote: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.draft_vote_path(conn, :show, id)

      conn = get(conn, Routes.draft_vote_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Draft vote"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.draft_vote_path(conn, :create), draft_vote: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Draft vote"
    end
  end

  describe "edit draft_vote" do
    setup [:create_draft_vote]

    test "renders form for editing chosen draft_vote", %{conn: conn, draft_vote: draft_vote} do
      conn = get(conn, Routes.draft_vote_path(conn, :edit, draft_vote))
      assert html_response(conn, 200) =~ "Edit Draft vote"
    end
  end

  describe "update draft_vote" do
    setup [:create_draft_vote]

    test "redirects when data is valid", %{conn: conn, draft_vote: draft_vote} do
      conn = put(conn, Routes.draft_vote_path(conn, :update, draft_vote), draft_vote: @update_attrs)
      assert redirected_to(conn) == Routes.draft_vote_path(conn, :show, draft_vote)

      conn = get(conn, Routes.draft_vote_path(conn, :show, draft_vote))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, draft_vote: draft_vote} do
      conn = put(conn, Routes.draft_vote_path(conn, :update, draft_vote), draft_vote: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Draft vote"
    end
  end

  describe "delete draft_vote" do
    setup [:create_draft_vote]

    test "deletes chosen draft_vote", %{conn: conn, draft_vote: draft_vote} do
      conn = delete(conn, Routes.draft_vote_path(conn, :delete, draft_vote))
      assert redirected_to(conn) == Routes.draft_vote_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.draft_vote_path(conn, :show, draft_vote))
      end
    end
  end

  defp create_draft_vote(_) do
    draft_vote = draft_vote_fixture()
    %{draft_vote: draft_vote}
  end
end
