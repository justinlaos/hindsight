defmodule HistoraWeb.AddTagsPlug do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  alias Histora.Tags

  @assigns_key :tags_for_decision

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, @assigns_key, Tags.list_organization_tags_for_decisions(conn.assigns.current_user.organization_id))
  end
end
