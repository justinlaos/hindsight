defmodule HistoraWeb.API.V1.DecisionController do
  use HistoraWeb, :controller

  alias HistoraWeb.APIAuthPlug
  alias Plug.Conn

  alias Histora.Goals
  alias Histora.Decisions

  def create(conn, %{"what" => what, "why" => why, "goal_list" => goal_list, "reference" => reference, "source" => source}) do
    case Decisions.create_decision(%{"user_id" => conn.assigns.current_user.id, "organization_id" => conn.assigns.current_user.organization_id, "what" => what, "why" => why, "reference" => reference, "source" => source }) do
      {:ok, decision} ->
        if goal_list != "" do
          Goals.assign_goals_to_decision(goal_list, decision.id, decision.organization_id, decision.user_id)
        end

        json(conn, %{status: 200, data: "decisioned created"})

      {:error} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Error creating decision"}})
    end
  end
end
