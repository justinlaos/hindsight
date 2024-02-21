defmodule HindsightWeb.MarketingControllerTest do
  use HindsightWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hindsight"
  end
end
