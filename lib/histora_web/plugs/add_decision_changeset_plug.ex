defmodule HistoraWeb.AddDecisionChangesetPlug do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  alias Histora.Decisions
  alias Histora.Decisions.Decision

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :decision_changeset, Decisions.change_decision(%Decision{}))
  end
end
