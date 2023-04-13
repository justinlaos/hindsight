defmodule HistoraWeb.DecisionController do
  use HistoraWeb, :controller

  alias Histora.Tags
  alias Histora.Users
  alias Histora.Decisions
  alias Histora.Teams
  alias Histora.Drafts
  alias Histora.Logs
  alias Histora.Decisions.Decision
  alias Histora.Reflections
  alias Histora.Reflections.Reflection

  def index(conn, params) do
    filtered_decisions =
      Decisions.list_organization_decisions(conn.assigns.organization)
      |> Decisions.filter_tags(params)
      |> Decisions.filter_users(params)
      |> Decisions.filter_teams(params)

    render(conn, "index.html",
      decision_changeset: Decisions.change_decision(%Decision{}),
      decisions: Decisions.formate_decisions(filtered_decisions, conn.assigns.current_user),
      decisions_count: Decisions.formate_decisions_count(filtered_decisions, conn.assigns.current_user),
      users: Users.get_organization_users(conn.assigns.organization),
      filterable_tags: Tags.list_organization_tags(conn.assigns.organization),
      filterable_users: Users.get_organization_users(conn.assigns.organization),
      filterable_teams: Teams.list_organization_teams(conn.assigns.organization, conn.assigns.current_user),
      selected_filtered_tags: (if Map.has_key?(params, "tag_list"), do: Tags.selected_filtered_tags(conn.assigns.organization, params["tag_list"]), else: [%{}]),
      selected_filtered_users: (if Map.has_key?(params, "users"), do: Users.selected_filtered_users(conn.assigns.organization, params["users"]), else: [%{}]),
      selected_filtered_teams: (if Map.has_key?(params, "teams"), do: Teams.selected_filtered_teams(conn.assigns.organization, params["teams"]), else: %{}),
      teams: Teams.list_organization_teams(conn.assigns.organization, conn.assigns.current_user),
      users_teams: Teams.list_user_teams(conn.assigns.current_user)
      )
  end

  def create(conn, params) do
    %{"tag_list" => tag_list} = params["decision"]
    teams = params["new_teams"]
    date = if Map.has_key?(params, "date"), do: params["date"], else: Date.to_string(Date.utc_today)
    reflection_date = if Map.has_key?(params, "reflection_date"), do: params["reflection_date"], else: nil
    approval_user = if Map.has_key?(params, "approval_user"), do: params["approval_user"], else: nil
    %{"redirect_to" => redirect_to} = params["decision"]

    case Decisions.create_decision(Map.merge(params["decision"], %{"user_id" => conn.assigns.current_user.id, "organization_id" => conn.assigns.organization.id, "date" => date, "reflection_date" => reflection_date})) do
      {:ok, decision} ->

        if tag_list != "" do
          Tags.assign_tags_to_decision(tag_list, decision.id, decision.organization_id, decision.user_id)
        end

        if teams != nil do
          Teams.assign_teams_to_decision(teams, decision.id)
        end

        if approval_user != nil do
          Decisions.create_decision_approval(decision.organization_id, approval_user, decision.id)
        end

        Histora.Logs.create_log(%{
          "organization_id" => conn.assigns.organization.id,
          "decision_id" => decision.id,
          "user_id" => conn.assigns.current_user.id,
          "event" => "created a decision" })

        Histora.Data.decision_event(conn.assigns.current_user, decision)

        conn
          |> put_flash(:info, "Decision created.")
          |> redirect(to: (if redirect_to != "", do: redirect_to, else: Routes.decision_path(conn, :show, decision)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    Histora.Data.page(conn.assigns.current_user, "Decision Show")

    render(conn, "show.html",
      decision: Decisions.get_decision!(id),
      decision_changeset: Decisions.change_decision(%Decision{}),
      edit_decision_changeset: Decisions.change_decision(Decisions.get_decision!(id)),
      teams: Teams.list_organization_teams(conn.assigns.organization, conn.assigns.current_user),
      users: Users.get_organization_users(conn.assigns.organization),
      reflection_changeset: Reflections.change_reflection(%Reflection{}),
      timeline: Decisions.get_timeline_for_decision(id)
    )
  end

  def update(conn, params) do
    id = params["id"]
    decision_params = params["decision"]
    team = if Map.has_key?(params, "new_teams"), do: params["new_teams"], else: nil
    users = if Map.has_key?(params, "users"), do:  params["users"], else: nil
    date = if Map.has_key?(params, "date"), do: params["date"], else: Date.to_string(Date.utc_today)
    reflection_date = if Map.has_key?(params, "reflection_date"), do: params["reflection_date"], else: nil
    approval_user = if Map.has_key?(params, "approval_user"), do: params["approval_user"], else: nil

    decision = Decisions.get_decision!(id)

    case Decisions.update_decision(decision, Map.merge(decision_params, %{"date" => date, "reflection_date" => reflection_date})) do
      {:ok, decision} ->

        Tags.delete_decision_tag_list(decision.id)
        Teams.delete_team_from_decision(decision.id)

        if decision_params["tag_list"] != "" do
          Tags.assign_tags_to_decision(decision_params["tag_list"], decision.id, decision.organization_id, decision.user_id)
        end

        if approval_user != nil do
          Decisions.create_decision_approval(decision.organization_id, approval_user, decision.id)
        end

        if team != nil do
          Teams.assign_teams_to_decision(team, decision.id)
        end

        if users != nil do
          Decisions.create_decision_users(users, decision.id)
        end

        Histora.Logs.create_log(%{
          "organization_id" => conn.assigns.organization.id,
          "decision_id" => decision.id,
          "user_id" => conn.assigns.current_user.id,
          "event" => "updated a decision" })

        Histora.Data.event(conn.assigns.current_user, "Updated Decision")

        conn
        |> put_flash(:info, "Decision updated successfully.")
        |> redirect(to: Routes.decision_path(conn, :show, decision))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", decision: decision, changeset: changeset)
    end
  end

  def update_decision_approval(conn, params) do
    Decisions.update_decision_approval(params["decision_id"], params["approved"], params["note"])
    conn
    |> put_flash(:info, "Decision was approved")
    |> redirect(to: Routes.decision_path(conn, :show, params["decision_id"]))
  end

  def reset_decision_approval(conn, params) do
    Decisions.reset_decision_approval(conn.assigns.organization.id, params["user_id"], params["id"])
    conn
    |> put_flash(:info, "Approval was approved")
    |> redirect(to: Routes.decision_path(conn, :show, params["id"]))
  end

  def delete(conn, %{"id" => id}) do
    decision = Decisions.get_decision!(id)
    {:ok, _decision} = Decisions.delete_decision(decision)

    conn
    |> put_flash(:info, "Decision deleted successfully.")
    |> redirect(to: Routes.decision_path(conn, :index))
  end
end
