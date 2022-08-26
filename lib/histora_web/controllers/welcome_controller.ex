defmodule HistoraWeb.WelcomeController do
  use HistoraWeb, :controller

  def getting_started(conn, _params) do
    Histora.Data.page(conn.assigns.current_user, "Welcome Getting Started")
    render(conn, "getting_started.html")
  end

  def admin(conn, _params) do
    Histora.Data.page(conn.assigns.current_user, "Welcome Admin")
    render(conn, "admin.html")
  end

  def complete_welcome(conn, _params) do
    Histora.Data.event(conn.assigns.current_user, "Complete Welcome Getting Started")

    user_data = Histora.Users.get_user_data_from_user(conn.assigns.current_user)
    case Histora.Users.update_user_data(user_data, %{getting_started_completed: true}) do
      {:ok, _user} ->
        conn
        |> redirect(to: Routes.welcome_path(conn, :admin))
      {:error, message} ->
        IO.inspect("ERROR: #{message}")
        conn
        |> redirect(to: Routes.welcome_path(conn, :getting_started))
    end
  end

  def complete_admin(conn, _params) do
    Histora.Data.event(conn.assigns.current_user, "Complete Welcome Admin")

    user_data = Histora.Users.get_user_data_from_user(conn.assigns.current_user)
    case Histora.Users.update_user_data(user_data, %{welcome_admin_completed: true}) do
      {:ok, _user} ->
        conn
        |> redirect(to: Routes.decision_path(conn, :index))
      {:error, message} ->
        IO.inspect("ERROR: #{message}")
        conn
        |> redirect(to: Routes.welcome_path(conn, :admin))
    end
  end
end
