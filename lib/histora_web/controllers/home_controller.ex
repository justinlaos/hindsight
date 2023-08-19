defmodule HistoraWeb.HomeController do
  use HistoraWeb, :controller

  alias Histora.Decisions
  alias Histora.Organizations
  alias Histora.Reflections

  def index(conn, _params) do
    decision_count = Decisions.organization_decision_count(conn.assigns.organization)
    reflection_count = Histora.Reflections.organization_reflection_count(conn.assigns.organization)
    reflection_successful_percentage = Histora.Reflections.organization_reflection_percentage_by_status(conn.assigns.organization, "successful")
    reflection_rethink_percentage = Histora.Reflections.organization_reflection_percentage_by_status(conn.assigns.organization, "rethink")
    users_scheduled_reflections = Histora.Reflections.users_scheduled_reflections(conn.assigns.organization, conn.assigns.current_user)
    users_past_due_reflections = Histora.Reflections.users_past_due_reflections(conn.assigns.organization, conn.assigns.current_user)
    logs = Histora.Logs.list_organization_decisions(conn.assigns.organization)
    users_active_approvals = Histora.Decisions.users_active_approvals(conn.assigns.organization, conn.assigns.current_user)

    Histora.Data.page(conn.assigns.current_user, "Home")


    render(conn, "index.html",
      free_plan_decision_limit_reached: Organizations.free_plan_decision_limit_reached(conn.assigns.organization),
      decision_changeset: Decisions.change_decision(%Decisions.Decision{}),
      decision_count: decision_count,
      reflection_count: reflection_count,
      reflection_successful_percentage: reflection_successful_percentage,
      reflection_rethink_percentage: reflection_rethink_percentage,
      goal_achieved_percentage: Histora.Goals.goals_percentage(conn.assigns.organization, true),
      goal_unachieved_percentage: Histora.Goals.goals_percentage(conn.assigns.organization, false),
      users_scheduled_reflections: users_scheduled_reflections,
      users_past_due_reflections: users_past_due_reflections,
      teams: Histora.Teams.list_organization_teams(conn.assigns.organization, conn.assigns.current_user),
      goals: Histora.Goals.list_organization_goals(conn.assigns.organization),
      users: Histora.Users.get_organization_users(conn.assigns.organization),
      logs: logs,
      users_active_approvals: users_active_approvals
    )
  end
end
