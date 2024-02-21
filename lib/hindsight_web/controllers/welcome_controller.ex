defmodule HindsightWeb.WelcomeController do
  use HindsightWeb, :controller

  def getting_started(conn, _params) do
    render(conn, "getting_started.html")
  end

  def admin(conn, _params) do
    render(conn, "admin.html")
  end

  def complete_welcome(conn, _params) do
    Hindsight.Data.event(conn.assigns.current_user, "Complete Getting Started")

    user_data = Hindsight.Users.get_user_data_from_user(conn.assigns.current_user)
    case Hindsight.Users.update_user_data(user_data, %{getting_started_completed: true}) do
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
    Hindsight.Data.event(conn.assigns.current_user, "Complete Getting Started Admin")

    user_data = Hindsight.Users.get_user_data_from_user(conn.assigns.current_user)
    case Hindsight.Users.update_user_data(user_data, %{welcome_admin_completed: true}) do
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
