defmodule HistoraWeb.API.V1.DecisionController do
  use HistoraWeb, :controller

  alias HistoraWeb.APIAuthPlug
  alias Plug.Conn

  alias Histora.Tags
  alias Histora.Decisions

  def create(conn, %{"content" => content, "tag_list" => tag_list, "reference" => reference, "source" => source}) do
    case Decisions.create_decision(%{"user_id" => conn.assigns.current_user.id, "organization_id" => conn.assigns.current_user.organization_id, "content" => content, "reference" => reference, "source" => source }) do
      {:ok, decision} ->
        if tag_list != "" do
          Tags.assign_tags_to_decision(tag_list, decision.id, decision.organization_id, decision.user_id)
        end

        json(conn, %{status: 200, data: "decisioned created"})

      {:error} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Error creating decision"}})
    end
  end
end
