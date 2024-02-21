defmodule HindsightWeb.GoalController do
  use HindsightWeb, :controller

  alias Hindsight.Goals
  alias Hindsight.Goals.Goal
  alias Hindsight.Decisions

  def index(conn, _params) do
    goals = Goals.list_organization_goals(conn.assigns.organization)
    Hindsight.Data.page(conn.assigns.current_user, "Goals Index")

    render(conn, "index.html",
      settings: true,
      goals: goals,
      goal_changeset: Goals.change_goal(%Goal{})
    )
  end

  def show(conn, params) do
    Hindsight.Data.page(conn.assigns.current_user, "Goal Show")

    render(conn, "show.html",
      goal: Goals.get_goal!(params["id"]),
      goal_achieved_percentage: Hindsight.Goals.goal_percentage(params["id"], true),
      goal_unachieved_percentage: Hindsight.Goals.goal_percentage(params["id"], false),
      decisions: Goals.get_decisions_for_goal(params) |> Decisions.formate_decisions(conn.assigns.current_user)
    )
  end

  def create(conn, params) do
    goal = params["goal"]

    case Goals.create_goal(%{"name" => goal["name"], "organization_id" => conn.assigns.organization.id, "user_id" => conn.assigns.current_user.id}) do
      {:ok, _goal} ->
        Hindsight.Data.event(conn.assigns.current_user, "Created Goal")

        conn
        |> put_flash(:info, "Goal created successfully.")
        |> redirect(to: Routes.goal_path(conn, :index))

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.goal_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "goal" => tag_params}) do
    goal = Goals.get_goal!(id)
    Hindsight.Data.event(conn.assigns.current_user, "Updated Goal")

    case Goals.update_goal(goal, tag_params) do
      {:ok, goal} ->
        conn
        |> put_flash(:info, "Goal updated successfully.")
        |> redirect(to: Routes.goal_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", goal: goal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    goal = Goals.get_goal!(id)
    {:ok, _goal} = Goals.delete_goal(goal)
    Hindsight.Data.event(conn.assigns.current_user, "Deleted Goal")

    conn
    |> put_flash(:info, "Goal deleted successfully.")
    |> redirect(to: Routes.goal_path(conn, :index))
  end
end
