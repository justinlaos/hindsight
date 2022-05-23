defmodule HistoraWeb.Tag_recordControllerTest do
  use HistoraWeb.ConnCase

  import Histora.TagsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all tag_records", %{conn: conn} do
      conn = get(conn, Routes.tag_record_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tag records"
    end
  end

  describe "new tag_record" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tag_record_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tag record"
    end
  end

  describe "create tag_record" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tag_record_path(conn, :create), tag_record: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tag_record_path(conn, :show, id)

      conn = get(conn, Routes.tag_record_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tag record"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tag_record_path(conn, :create), tag_record: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tag record"
    end
  end

  describe "edit tag_record" do
    setup [:create_tag_record]

    test "renders form for editing chosen tag_record", %{conn: conn, tag_record: tag_record} do
      conn = get(conn, Routes.tag_record_path(conn, :edit, tag_record))
      assert html_response(conn, 200) =~ "Edit Tag record"
    end
  end

  describe "update tag_record" do
    setup [:create_tag_record]

    test "redirects when data is valid", %{conn: conn, tag_record: tag_record} do
      conn = put(conn, Routes.tag_record_path(conn, :update, tag_record), tag_record: @update_attrs)
      assert redirected_to(conn) == Routes.tag_record_path(conn, :show, tag_record)

      conn = get(conn, Routes.tag_record_path(conn, :show, tag_record))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, tag_record: tag_record} do
      conn = put(conn, Routes.tag_record_path(conn, :update, tag_record), tag_record: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tag record"
    end
  end

  describe "delete tag_record" do
    setup [:create_tag_record]

    test "deletes chosen tag_record", %{conn: conn, tag_record: tag_record} do
      conn = delete(conn, Routes.tag_record_path(conn, :delete, tag_record))
      assert redirected_to(conn) == Routes.tag_record_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.tag_record_path(conn, :show, tag_record))
      end
    end
  end

  defp create_tag_record(_) do
    tag_record = tag_record_fixture()
    %{tag_record: tag_record}
  end
end
