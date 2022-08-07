defmodule HistoraWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias HistoraWeb.Router.Helpers, as: Routes

  @impl true
  def after_sign_in_path(conn), do: Routes.decision_path(conn, :index)
end
