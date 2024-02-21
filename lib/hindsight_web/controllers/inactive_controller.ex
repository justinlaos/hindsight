defmodule HindsightWeb.InactiveController do
  use HindsightWeb, :controller

  def paused(conn, _params) do
    Hindsight.Data.page(conn.assigns.current_user, "Account Paused")
    render(conn, "paused.html")
  end

  def trial_expired(conn, _params) do
    Hindsight.Data.page(conn.assigns.current_user, "Account Trial Expired")
    render(conn, "trial_expired.html")
  end
end
