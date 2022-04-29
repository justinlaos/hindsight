defmodule HistoraWeb.MarketingControllerTest do
  use HistoraWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Histora"
  end
end
