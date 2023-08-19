defmodule HistoraWeb.ReflectionController do
  use HistoraWeb, :controller

  alias Histora.Reflections
  alias Histora.Reflections.Reflection
  alias Histora.Decisions

  def index(conn, params) do
    formated_start_date = if Map.has_key?(params, "dates") && params["dates"] != "" do
      Decisions.get_param_start_date(params)
    else
      date_string = Date.to_string(Date.utc_today)
      {:ok, formated_start_date} = NaiveDateTime.new Date.from_iso8601!(date_string), ~T[00:00:00]
      formated_start_date
    end

    formated_end_date = if Map.has_key?(params, "dates") && params["dates"] != "" do
      Decisions.get_param_end_date(params)
    else
      date_string = Date.to_string(Date.utc_today |> Date.add(+7))
      {:ok, formated_end_date} = NaiveDateTime.new Date.from_iso8601!(date_string), ~T[23:59:59]
      formated_end_date
    end

    reflections = Reflections.list_reflections()
    decisions = Reflections.list_upcoming_reflection_decisions(conn.assigns.organization, formated_start_date, formated_end_date, conn.assigns.current_user)
    past_due_decisions = Reflections.list_past_due_reflection_decisions(conn.assigns.organization, conn.assigns.current_user)

    render(conn, "index.html",
      reflections: reflections,
      decisions: decisions,
      formated_start_date: formated_start_date,
      formated_end_date: formated_end_date,
      past_due_decisions: past_due_decisions)
  end

  def past_due(conn, _params) do
    past_due_decisions = Reflections.list_past_due_reflection_decisions(conn.assigns.organization, conn.assigns.current_user)
    render(conn, "past_due.html", past_due_decisions: past_due_decisions)
  end

  def all_reflection_decsions(conn, _params) do
    all_reflection_decisions = Reflections.list_all_reflection_decisions(conn.assigns.organization, conn.assigns.current_user)
    render(conn, "all_reflection_decsions.html", all_reflection_decisions: all_reflection_decisions)
  end

  def new(conn, _params) do
    changeset = Reflections.change_reflection(%Reflection{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do

    case Reflections.create_reflection(Map.merge(params["reflection"], %{"decision_id" => params["decision"], "user_id" => conn.assigns.current_user.id, "organization_id" => conn.assigns.organization.id, "status" => params["status"]})) do
      {:ok, reflection} ->

        if params["goals"] do
          Reflections.create_reflection_goals(params["goals"], reflection.id, params["decision"], conn.assigns.current_user.id, conn.assigns.organization.id)
        end

        Histora.Logs.create_log(%{
          "organization_id" => conn.assigns.organization.id,
          "decision_id" => reflection.decision_id,
          "user_id" => conn.assigns.current_user.id,
          "event" => "created a reflection" })

        Histora.Data.event(conn.assigns.current_user, "Created Reflection")

        conn
        |> put_flash(:info, "Reflection created successfully.")
        |> redirect(to: Routes.decision_path(conn, :show, params["decision"]))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reflection = Reflections.get_reflection!(id)
    render(conn, "show.html", reflection: reflection)
  end

  def edit(conn, %{"id" => id}) do
    reflection = Reflections.get_reflection!(id)
    changeset = Reflections.change_reflection(reflection)
    render(conn, "edit.html", reflection: reflection, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reflection" => reflection_params, "status" => status, "goals" => goals}) do
    reflection = Reflections.get_reflection!(id)

    case Reflections.update_reflection(reflection, Map.merge(reflection_params, %{"status" => status})) do
      {:ok, reflection} ->

        Reflections.update_reflection_goals(goals)

        Histora.Logs.create_log(%{
          "organization_id" => conn.assigns.organization.id,
          "decision_id" => reflection.decision_id,
          "user_id" => conn.assigns.current_user.id,
          "event" => "updated a reflection" })

        Histora.Data.event(conn.assigns.current_user, "Updated Reflection")

        conn
        |> put_flash(:info, "Reflection updated successfully.")
        |> redirect(to: Routes.decision_path(conn, :show, reflection.decision_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", reflection: reflection, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reflection = Reflections.get_reflection!(id)
    {:ok, _reflection} = Reflections.delete_reflection(reflection)

    Histora.Data.event(conn.assigns.current_user, "Deleted Reflection")

    conn
    |> put_flash(:info, "Reflection deleted successfully.")
    |> redirect(to: Routes.reflection_path(conn, :index))
  end
end
