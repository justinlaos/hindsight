defmodule HistoraWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias HistoraWeb.Router.Helpers, as: Routes

  @impl true
  def after_sign_in_path(conn), do: Routes.organization_path(conn, :home)
end
