defmodule HindsightWeb.EnsureUserActivePlug do
  @moduledoc """
  This plug ensures that a user is active by not being archived.

  ## Example

      plug HindsightWeb.EnsureUserActivePlug
  """
  import Plug.Conn, only: [halt: 1]

  alias HindsightWeb.Router.Helpers, as: Routes
  alias Phoenix.Controller
  alias Plug.Conn
  alias Pow.Plug

  @doc false
  @spec init(any()) :: any()
  def init(opts), do: opts

  @doc false
  @spec call(Conn.t(), any()) :: Conn.t()
  def call(conn, _opts) do
    conn
    |> Plug.current_user()
    |> archived?()
    |> maybe_halt(conn)
  end

  defp archived?(%{archived_at: archived_at}) when not is_nil(archived_at), do: true
  defp archived?(_user), do: false

  defp maybe_halt(true, conn) do
    conn
    |> Plug.delete()
    |> Controller.put_flash(:error, "Sorry, your were archived. Speak to your admin to regain access")
    |> Controller.redirect(to: Routes.pow_session_path(conn, :new))
    |> halt()
  end
  defp maybe_halt(_any, conn), do: conn
end
