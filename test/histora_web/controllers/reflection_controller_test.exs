defmodule HistoraWeb.ReflectionControllerTest do
  use HistoraWeb.ConnCase

  import Histora.ReflectionsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all reflections", %{conn: conn} do
      conn = get(conn, Routes.reflection_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Reflections"
    end
  end

  describe "new reflection" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.reflection_path(conn, :new))
      assert html_response(conn, 200) =~ "New Reflection"
    end
  end

  describe "create reflection" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.reflection_path(conn, :create), reflection: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.reflection_path(conn, :show, id)

      conn = get(conn, Routes.reflection_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Reflection"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.reflection_path(conn, :create), reflection: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Reflection"
    end
  end

  describe "edit reflection" do
    setup [:create_reflection]

    test "renders form for editing chosen reflection", %{conn: conn, reflection: reflection} do
      conn = get(conn, Routes.reflection_path(conn, :edit, reflection))
      assert html_response(conn, 200) =~ "Edit Reflection"
    end
  end

  describe "update reflection" do
    setup [:create_reflection]

    test "redirects when data is valid", %{conn: conn, reflection: reflection} do
      conn = put(conn, Routes.reflection_path(conn, :update, reflection), reflection: @update_attrs)
      assert redirected_to(conn) == Routes.reflection_path(conn, :show, reflection)

      conn = get(conn, Routes.reflection_path(conn, :show, reflection))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, reflection: reflection} do
      conn = put(conn, Routes.reflection_path(conn, :update, reflection), reflection: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Reflection"
    end
  end

  describe "delete reflection" do
    setup [:create_reflection]

    test "deletes chosen reflection", %{conn: conn, reflection: reflection} do
      conn = delete(conn, Routes.reflection_path(conn, :delete, reflection))
      assert redirected_to(conn) == Routes.reflection_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.reflection_path(conn, :show, reflection))
      end
    end
  end

  defp create_reflection(_) do
    reflection = reflection_fixture()
    %{reflection: reflection}
  end
end
