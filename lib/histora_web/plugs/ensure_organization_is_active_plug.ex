defmodule HistoraWeb.EnsureOrganizationIsActivePlug do
  @moduledoc """
  This plug ensures that a user is active by not being archived.

  ## Example

      plug HistoraWeb.EnsureUserActivePlug
  """
  import Plug.Conn, only: [halt: 1]

  alias HistoraWeb.Router.Helpers, as: Routes
  alias Phoenix.Controller
  alias Histora.Organizations
  alias Plug.Conn
  alias Pow.Plug

  @doc false
  @spec init(any()) :: any()
  def init(opts), do: opts

  @doc false
  @spec call(Conn.t(), any()) :: Conn.t()
  def call(conn, _opts) do
    conn
    Organizations.get_organization_by_current_user(conn.assigns.current_user)
    |> active?()
    |> maybe_halt(conn)
  end

  defp active?(%{status: status}), do: Enum.member?(["paused", "cancled"], status)
  defp active?(_user), do: false

  defp maybe_halt(true, conn) do
    conn
    |> Controller.put_flash(:error, "Sorry, your organization is paused. Please update account to active in billing")
    |> Controller.redirect(to: Routes.paused_path(conn, :paused))
    |> halt()
  end
  defp maybe_halt(_any, conn), do: conn
end
