defmodule HistoraWeb.Admin.UserController do
  use HistoraWeb, :controller

  alias Plug.Conn
  alias Pow.{Plug, Operations}
  alias Histora.Users

  plug :load_user when action in [:archive, :unarchive, :cancel_invite]

  # ...

  def archive(%{assigns: %{user: user}} = conn, _params) do
    case Users.archive(user) do
      {:ok, _user} ->
        Histora.Data.event(conn.assigns.current_user, "Archived A User")
        conn
        |> put_flash(:info, "User has been archived.")
        |> redirect(to: Routes.settings_path(conn, :organization))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "User couldn't be archived.")
        |> redirect(to: Routes.settings_path(conn, :organization))
    end
  end

  def unarchive(%{assigns: %{user: user}} = conn, _params) do
    case Users.unarchive(user) do
      {:ok, _user} ->
        Histora.Data.event(conn.assigns.current_user, "Unarchived A User")
        conn
        |> put_flash(:info, "User has been unarchived.")
        |> redirect(to: Routes.settings_path(conn, :organization))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "User couldn't be unarchived.")
        |> redirect(to: Routes.settings_path(conn, :organization))
    end
  end

  def cancel_invite(%{assigns: %{user: user}} = conn, _params) do
    case Users.cancel_invite(user) do
      {_id, _user} ->
        Histora.Data.event(conn.assigns.current_user, "Canceled Invite")
        conn
        |> put_flash(:info, "Invitation has been cancelled.")
        |> redirect(to: Routes.settings_path(conn, :organization))
    end
  end

  defp load_user(%{params: %{"id" => user_id}} = conn, _opts) do
    config = Plug.fetch_config(conn)

    case Operations.get_by([id: user_id], config) do
      nil ->
        conn
        |> put_flash(:error, "User doesn't exist")
        |> redirect(to: "/")

      user ->
        assign(conn, :user, user)
    end
  end
end
