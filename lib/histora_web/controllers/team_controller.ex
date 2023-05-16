defmodule HistoraWeb.TeamController do
  use HistoraWeb, :controller

  alias Histora.Teams
  alias Histora.Users
  alias Histora.Teams.Team

  def index(conn, _params) do
    teams = Teams.list_all_organization_teams(conn.assigns.organization, conn.assigns.current_user)
    users_teams = Teams.list_user_teams(conn.assigns.current_user)
    team_changeset = Teams.change_team(%Team{})
    users = Users.get_organization_users(conn.assigns.organization)
    Histora.Data.page(conn.assigns.current_user, "Team Index")

    render(conn, "index.html", teams: teams, team_changeset: team_changeset, users: users, users_teams: users_teams)
  end

  def create(conn, params) do
    team = params["team"]
    private = params["private"]
    team_users = if Map.has_key?(params, "users_list"), do: params["users_list"], else: ""

    case Teams.create_team(%{"private" => private, "name" => team["name"], "organization_id" => conn.assigns.organization.id}) do
      {:ok, team} ->

        if team_users != "" do
          Teams.create_team_users(team_users, team.id)
        end

        Histora.Data.event(conn.assigns.current_user, "Created Team")

        conn
        |> put_flash(:info, "Team created successfully.")
        |> redirect(to: Routes.team_path(conn, :index))

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.team_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "team" => team_params, "users_list" => users_list, "private" => private}) do
    # %{"id" => id, "team" => team_params, "users_list" => users_list}
    team = Teams.get_team!(id)

    case Teams.update_team(team, Map.merge(team_params, %{"private" => private})) do
      {:ok, team} ->

        if users_list != "" do
          Teams.update_team_users(users_list, team.id)
        end

        Histora.Data.event(conn.assigns.current_user, "Updated Team")

        conn
        |> put_flash(:info, "Team updated successfully.")
        |> redirect(to: Routes.team_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Error updating team")
        |> redirect(to: Routes.team_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    case Teams.update_team(team, team_params) do
      {:ok, team} ->

        Teams.update_team_users([], team.id)

        Histora.Data.event(conn.assigns.current_user, "Updated Team")

        conn
        |> put_flash(:info, "Team updated successfully.")
        |> redirect(to: Routes.team_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", team: team, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    {:ok, _team} = Teams.delete_team(team)

    Histora.Data.event(conn.assigns.current_user, "Deleted Team")

    conn
    |> put_flash(:info, "Team deleted successfully.")
    |> redirect(to: Routes.team_path(conn, :index))
  end
end
