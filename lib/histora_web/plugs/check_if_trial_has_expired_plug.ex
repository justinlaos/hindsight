defmodule HistoraWeb.CheckIfTrialHasExpiredPlug do
  import Plug.Conn, only: [halt: 1]

  alias HistoraWeb.Router.Helpers, as: Routes
  alias Phoenix.Controller
  alias Histora.Organizations

  def init(opts), do: opts

  def call(conn, _opts) do
    Organizations.get_organization_by_current_user(conn.assigns.current_user)
    |> active?()
    |> maybe_halt(conn)
  end

  defp active?(%{status: status}), do: Enum.member?(["trial_expired"], status)
  defp active?(_user), do: false

  defp maybe_halt(true, conn) do
    conn
    |> Controller.redirect(to: Routes.inactive_path(conn, :trial_expired))
    |> halt()
  end
  defp maybe_halt(_any, conn), do: conn
end
