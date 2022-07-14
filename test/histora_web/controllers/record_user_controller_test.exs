defmodule HistoraWeb.Record_userControllerTest do
  use HistoraWeb.ConnCase

  import Histora.RecordsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all record_users", %{conn: conn} do
      conn = get(conn, Routes.record_user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Record users"
    end
  end

  describe "new record_user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.record_user_path(conn, :new))
      assert html_response(conn, 200) =~ "New Record user"
    end
  end

  describe "create record_user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.record_user_path(conn, :create), record_user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.record_user_path(conn, :show, id)

      conn = get(conn, Routes.record_user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Record user"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.record_user_path(conn, :create), record_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Record user"
    end
  end

  describe "edit record_user" do
    setup [:create_record_user]

    test "renders form for editing chosen record_user", %{conn: conn, record_user: record_user} do
      conn = get(conn, Routes.record_user_path(conn, :edit, record_user))
      assert html_response(conn, 200) =~ "Edit Record user"
    end
  end

  describe "update record_user" do
    setup [:create_record_user]

    test "redirects when data is valid", %{conn: conn, record_user: record_user} do
      conn = put(conn, Routes.record_user_path(conn, :update, record_user), record_user: @update_attrs)
      assert redirected_to(conn) == Routes.record_user_path(conn, :show, record_user)

      conn = get(conn, Routes.record_user_path(conn, :show, record_user))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, record_user: record_user} do
      conn = put(conn, Routes.record_user_path(conn, :update, record_user), record_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Record user"
    end
  end

  describe "delete record_user" do
    setup [:create_record_user]

    test "deletes chosen record_user", %{conn: conn, record_user: record_user} do
      conn = delete(conn, Routes.record_user_path(conn, :delete, record_user))
      assert redirected_to(conn) == Routes.record_user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.record_user_path(conn, :show, record_user))
      end
    end
  end

  defp create_record_user(_) do
    record_user = record_user_fixture()
    %{record_user: record_user}
  end
end
