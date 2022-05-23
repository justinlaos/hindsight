defmodule HistoraWeb.Tag_recordController do
  use HistoraWeb, :controller

  alias Histora.Tags
  alias Histora.Tags.Tag_record

  def index(conn, _params) do
    tag_records = Tags.list_tag_records()
    render(conn, "index.html", tag_records: tag_records)
  end

  def new(conn, _params) do
    changeset = Tags.change_tag_record(%Tag_record{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tag_record" => tag_record_params}) do
    case Tags.create_tag_record(tag_record_params) do
      {:ok, tag_record} ->
        conn
        |> put_flash(:info, "Tag record created successfully.")
        |> redirect(to: Routes.tag_record_path(conn, :show, tag_record))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tag_record = Tags.get_tag_record!(id)
    render(conn, "show.html", tag_record: tag_record)
  end

  def edit(conn, %{"id" => id}) do
    tag_record = Tags.get_tag_record!(id)
    changeset = Tags.change_tag_record(tag_record)
    render(conn, "edit.html", tag_record: tag_record, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tag_record" => tag_record_params}) do
    tag_record = Tags.get_tag_record!(id)

    case Tags.update_tag_record(tag_record, tag_record_params) do
      {:ok, tag_record} ->
        conn
        |> put_flash(:info, "Tag record updated successfully.")
        |> redirect(to: Routes.tag_record_path(conn, :show, tag_record))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tag_record: tag_record, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag_record = Tags.get_tag_record!(id)
    {:ok, _tag_record} = Tags.delete_tag_record(tag_record)

    conn
    |> put_flash(:info, "Tag record deleted successfully.")
    |> redirect(to: Routes.tag_record_path(conn, :index))
  end
end
