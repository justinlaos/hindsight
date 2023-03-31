defmodule HistoraWeb.HomeController do
  use HistoraWeb, :controller

  alias Histora.Decisions
  alias Histora.Reflections

  def index(conn, _params) do
    decision_count = Decisions.organization_decision_count(conn.assigns.organization)
    reflection_count = Histora.Reflections.organization_reflection_count(conn.assigns.organization)
    reflection_continuation_percentage = Histora.Reflections.organization_reflection_percentage_by_status(conn.assigns.organization, "continuation")
    reflection_reversal_percentage = Histora.Reflections.organization_reflection_percentage_by_status(conn.assigns.organization, "reversal")
    users_scheduled_reflections = Histora.Reflections.users_scheduled_reflections(conn.assigns.organization, conn.assigns.current_user)
    users_past_due_reflections = Histora.Reflections.users_past_due_reflections(conn.assigns.organization, conn.assigns.current_user)
    logs = Histora.Logs.list_organization_decisions(conn.assigns.organization)
    users_active_approvals = Histora.Decisions.users_active_approvals(conn.assigns.organization, conn.assigns.current_user)


    render(conn, "index.html",
      decision_count: decision_count,
      reflection_count: reflection_count,
      reflection_continuation_percentage: reflection_continuation_percentage,
      reflection_reversal_percentage: reflection_reversal_percentage,
      users_scheduled_reflections: users_scheduled_reflections,
      users_past_due_reflections: users_past_due_reflections,
      logs: logs,
      users_active_approvals: users_active_approvals
    )
  end
end
