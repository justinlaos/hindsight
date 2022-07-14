defmodule HistoraWeb.AddRecordChangesetPlug do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  alias Histora.Records
  alias Histora.Records.Record

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :record_changeset, Records.change_record(%Record{}))
  end
end
