defmodule HistoraWeb.RecordController do
  use HistoraWeb, :controller

  alias Histora.Tags
  alias Histora.Records
  alias Histora.Records.Record

  def index(conn, _params) do
    records = Records.list_organization_records(conn.assigns.organization)
    records_count = Records.organization_records_count(conn.assigns.organization)
    render(conn, "index.html", records: records, records_count: records_count)
  end

  def new(conn, _params) do
    changeset = Records.change_record(%Record{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"record" => record_params}) do
    %{"tag_list" => tag_list} = record_params
    %{"redirect_to" => redirect_to} = record_params

    case Records.create_record(Map.merge(record_params, %{"user_id" => conn.assigns.current_user.id, "organization_id" => conn.assigns.organization.id})) do
      {:ok, record} ->
        Tags.assign_tags_to_record(tag_list, record.id, record.organization_id, record.user_id)
        conn
        |> put_flash(:info, "Record created.")
        |> redirect(to: redirect_to)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    record = Records.get_record!(id)
    render(conn, "show.html", record: record)
  end

  def edit(conn, %{"id" => id}) do
    record = Records.get_record!(id)
    changeset = Records.change_record(record)
    render(conn, "edit.html", record: record, changeset: changeset)
  end

  def update(conn, %{"id" => id, "record" => record_params}) do
    record = Records.get_record!(id)

    case Records.update_record(record, record_params) do
      {:ok, record} ->
        conn
        |> put_flash(:info, "Record updated successfully.")
        |> redirect(to: Routes.record_path(conn, :show, record))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", record: record, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    record = Records.get_record!(id)
    {:ok, _record} = Records.delete_record(record)

    conn
    |> put_flash(:info, "Record deleted successfully.")
    |> redirect(to: Routes.record_path(conn, :index))
  end
end
