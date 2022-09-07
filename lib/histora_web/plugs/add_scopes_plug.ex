defmodule HistoraWeb.AddScopesPlug do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  alias Histora.Scopes

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :scopes, Scopes.list_organization_scopes(conn.assigns.organization, conn.assigns.current_user))
  end
end
