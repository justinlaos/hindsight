defmodule HistoraWeb.PausedController do
  use HistoraWeb, :controller

  def paused(conn, _params) do
    render(conn, "paused.html")
  end
end
