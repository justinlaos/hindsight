defmodule HistoraWeb.ScopeOrganization do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  alias Histora.Organizations

  @assigns_key :organization

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, @assigns_key, Organizations.get_organization_by_current_user(conn.assigns.current_user))
  end
end
