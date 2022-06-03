defmodule HistoraWeb.AddRecordChangesetPlug do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  alias Histora.Records
  alias Histora.Records.Record

  @assigns_key :record_changeset

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, @assigns_key, Records.change_record(%Record{}))
  end
end
