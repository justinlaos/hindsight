defmodule HistoraWeb.InactiveController do
  use HistoraWeb, :controller

  def paused(conn, _params) do
    render(conn, "paused.html")
  end

  def trial_expired(conn, _params) do
    render(conn, "trial_expired.html")
  end
end
