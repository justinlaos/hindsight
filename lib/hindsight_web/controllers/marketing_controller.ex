defmodule HindsightWeb.MarketingController do
  use HindsightWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
