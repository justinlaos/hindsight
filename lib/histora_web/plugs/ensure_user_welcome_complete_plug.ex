defmodule HistoraWeb.EnsureUserWelcomeCompletePlug do
  @moduledoc """
  This plug ensures that a user is active by not being archived.

  ## Example

      plug HistoraWeb.EnsureUserActivePlug
  """
  import Plug.Conn, only: [halt: 1]

  alias HistoraWeb.Router.Helpers, as: Routes
  alias Phoenix.Controller
  alias Histora.Repo
  alias Plug.Conn
  alias Pow.Plug

  @doc false
  @spec init(any()) :: any()
  def init(opts), do: opts

  @doc false
  @spec call(Conn.t(), any()) :: Conn.t()
  def call(conn, _opts) do
    completed?(conn, Plug.current_user(conn))
  end

  defp completed?(conn, user) do
    user_data = Histora.Users.get_user_data_from_user(user)
    if user_data do
      if user_data.getting_started_completed == false do
        conn
        |> Controller.redirect(to: Routes.welcome_path(conn, :getting_started))
        |> halt()
      end
      if user_data.welcome_admin_completed == false do
        conn
        |> Controller.redirect(to: Routes.welcome_path(conn, :admin))
        |> halt()
      end
      if user_data.getting_started_completed == true && user_data.welcome_admin_completed == true do
        conn
      end
    end
  end
end
