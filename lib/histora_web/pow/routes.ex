defmodule HistoraWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias HistoraWeb.Router.Helpers, as: Routes

  @impl true
  def after_sign_in_path(conn) do
    Histora.Data.event(conn.assigns.current_user, "Logged In")
    Routes.decision_path(conn, :index)
  end

  @impl true
  def after_sign_out_path(conn) do
    Histora.Data.event(conn.assigns.current_user, "Logged Out")
    Routes.pow_session_path(conn, :new)
  end
end
