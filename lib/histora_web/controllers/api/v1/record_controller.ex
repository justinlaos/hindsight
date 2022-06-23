defmodule HistoraWeb.API.V1.RecordController do
  use HistoraWeb, :controller

  alias HistoraWeb.APIAuthPlug
  alias Plug.Conn

  alias Histora.Tags
  alias Histora.Records

  def create(conn, %{"content" => content, "tag_list" => tag_list, "reference" => reference, "source" => source}) do
    case Records.create_record(%{"user_id" => conn.assigns.current_user.id, "organization_id" => conn.assigns.current_user.organization_id, "content" => content, "reference" => reference, "source" => source }) do
      {:ok, record} ->
        Tags.assign_tags_to_record(tag_list, record.id, record.organization_id, record.user_id)

        json(conn, %{status: 200, data: "recorded created"})

      {:error} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Error creating record"}})
    end
  end
end
