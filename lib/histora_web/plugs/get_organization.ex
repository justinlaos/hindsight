defmodule HistoraWeb.GetOrganization do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :organization, Histora.Organizations.get_organization_by_current_user(conn.assigns.current_user))
  end
end
