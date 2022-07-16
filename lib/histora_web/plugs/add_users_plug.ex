defmodule HistoraWeb.AddUsersPlug do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  alias Histora.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :users, Users.get_organization_users(conn.assigns.organization))
  end
end
