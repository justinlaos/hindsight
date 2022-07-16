defmodule HistoraWeb.RecordController do
  use HistoraWeb, :controller

  alias Histora.Tags
  alias Histora.Users
  alias Histora.Records
  alias Histora.Scopes
  alias Histora.Records.Record

  def index(conn, params) do

    formated_start_date = if Map.has_key?(params, "dates") && params["dates"] != "" do
      Records.get_param_start_date(params)
    else
      date_string = Date.to_string(Date.utc_today |> Date.add(-7))
      {:ok, formated_start_date} = NaiveDateTime.new Date.from_iso8601!(date_string), ~T[00:00:00]
      formated_start_date
    end


    formated_end_date = if Map.has_key?(params, "dates") && params["dates"] != "" do
      Records.get_param_end_date(params)
    else
      date_string = Date.to_string(Date.utc_today)
      {:ok, formated_end_date} = NaiveDateTime.new Date.from_iso8601!(date_string), ~T[23:59:59]
      formated_end_date
    end

    sorted_records =
      Records.list_organization_records(conn.assigns.organization)
      |> Records.filter_tags(params)
      |> Records.filter_users(params)
      |> Records.filter_dates(formated_start_date, formated_end_date)

    records =  Records.formate_records(sorted_records, conn.assigns.current_user)
    records_count =  Records.formate_records_count(sorted_records)

    filterable_tags = Tags.list_organization_tags(conn.assigns.organization)
    filterable_users = Users.get_organization_users(conn.assigns.organization)
    selected_filtered_tags = if Map.has_key?(params, "tag_list"), do: Tags.selected_filtered_tags(conn.assigns.organization, params["tag_list"]), else: %{}
    selected_filtered_users = if Map.has_key?(params, "users"), do: Users.selected_filtered_users(conn.assigns.organization, params["users"]), else: %{}


    render(conn, "index.html",
      records: records,
      records_count: records_count,
      filterable_tags: filterable_tags,
      filterable_users: filterable_users,
      selected_filtered_tags: selected_filtered_tags,
      selected_filtered_users: selected_filtered_users,
      formated_start_date: formated_start_date,
      formated_end_date: formated_end_date
      )
  end

  def new(conn, _params) do
    changeset = Records.change_record(%Record{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    %{"tag_list" => tag_list} = params["record"]
    scope = params["scope"]
    private = params["private"]
    users = params["users"]
    %{"redirect_to" => redirect_to} = params["record"]

    case Records.create_record(Map.merge(params["record"], %{"private" => private, "user_id" => conn.assigns.current_user.id, "organization_id" => conn.assigns.organization.id})) do
      {:ok, record} ->

        if tag_list != "" do
          Tags.assign_tags_to_record(tag_list, record.id, record.organization_id, record.user_id)
        end

        if scope != nil do
          {:ok, scope_record} = Scopes.assign_scope_to_record(scope, record.id)
        end

        if Map.has_key?(params, "users") && users != "" do
          Records.create_record_users(users, record.id)
        end

        conn
          |> put_flash(:info, "Record created.")
          |> redirect(to: redirect_to)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    record = Records.get_record!(id)
    edit_record_changeset = Records.change_record(record)
    scopes = Scopes.list_organization_scopes(conn.assigns.organization)
    render(conn, "show.html",
      record: record,
      edit_record_changeset: edit_record_changeset,
      scopes: scopes
    )
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
