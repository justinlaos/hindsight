defmodule HistoraWeb.AuthErrorHandler do
  use HistoraWeb, :controller
  alias Plug.Conn

  @spec call(Conn.t(), atom()) :: Conn.t()
  def call(conn, :not_authenticated) do
    conn
    |> put_flash(:error, "You've to be authenticated first")
    |> redirect(to: Routes.login_path(conn, :new))
  end

  @spec call(Conn.t(), atom()) :: Conn.t()
  def call(conn, :already_authenticated) do
    conn
    |> put_flash(:error, "You're already authenticated")
    |> redirect(to: Routes.decision_path(conn, :index))
  end
end
