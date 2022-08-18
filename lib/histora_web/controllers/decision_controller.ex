defmodule HistoraWeb.DecisionController do
  use HistoraWeb, :controller

  alias Histora.Tags
  alias Histora.Users
  alias Histora.Decisions
  alias Histora.Scopes
  alias Histora.Drafts
  alias Histora.Decisions.Decision
  alias Histora.Reflections
  alias Histora.Reflections.Reflection

  def index(conn, params) do

    formated_start_date = if Map.has_key?(params, "dates") && params["dates"] != "" do
      Decisions.get_param_start_date(params)
    else
      date_string = Date.to_string(Date.utc_today |> Date.add(-7))
      {:ok, formated_start_date} = NaiveDateTime.new Date.from_iso8601!(date_string), ~T[00:00:00]
      formated_start_date
    end


    formated_end_date = if Map.has_key?(params, "dates") && params["dates"] != "" do
      Decisions.get_param_end_date(params)
    else
      date_string = Date.to_string(Date.utc_today)
      {:ok, formated_end_date} = NaiveDateTime.new Date.from_iso8601!(date_string), ~T[23:59:59]
      formated_end_date
    end

    sorted_decisions =
      Decisions.list_organization_decisions(conn.assigns.organization)
      |> Decisions.filter_tags(params)
      |> Decisions.filter_users(params)
      |> Decisions.filter_dates(formated_start_date, formated_end_date)

    decisions =  Decisions.formate_decisions(sorted_decisions, conn.assigns.current_user)
    decisions_count =  Decisions.formate_decisions_count(sorted_decisions)

    filterable_tags = Tags.list_organization_tags(conn.assigns.organization)
    filterable_users = Users.get_organization_users(conn.assigns.organization)
    selected_filtered_tags = if Map.has_key?(params, "tag_list"), do: Tags.selected_filtered_tags(conn.assigns.organization, params["tag_list"]), else: %{}
    selected_filtered_users = if Map.has_key?(params, "users"), do: Users.selected_filtered_users(conn.assigns.organization, params["users"]), else: %{}


    render(conn, "index.html",
      decisions: decisions,
      decisions_count: decisions_count,
      filterable_tags: filterable_tags,
      filterable_users: filterable_users,
      selected_filtered_tags: selected_filtered_tags,
      selected_filtered_users: selected_filtered_users,
      formated_start_date: formated_start_date,
      formated_end_date: formated_end_date
      )
  end

  def new(conn, _params) do
    changeset = Decisions.change_decision(%Decision{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    %{"tag_list" => tag_list} = params["decision"]
    scopes = params["new_scopes"]
    private = params["private"]
    users = params["new_users"]
    date = if Map.has_key?(params, "date"), do: params["date"], else: Date.to_string(Date.utc_today)
    reflection_date = if Map.has_key?(params, "reflection_date"), do: params["reflection_date"], else: nil
    %{"redirect_to" => redirect_to} = params["decision"]

    case Decisions.create_decision(Map.merge(params["decision"], %{"private" => private, "user_id" => conn.assigns.current_user.id, "organization_id" => conn.assigns.organization.id, "date" => date, "reflection_date" => reflection_date})) do
      {:ok, decision} ->

        if tag_list != "" do
          Tags.assign_tags_to_decision(tag_list, decision.id, decision.organization_id, decision.user_id)
        end

        if scopes != nil do
          Scopes.assign_scopes_to_decision(scopes, decision.id)
        end

        if Map.has_key?(params, "new_users") && users != "" do
          Decisions.create_decision_users(users, decision.id)
        end

        conn
          |> put_flash(:info, "Decision created.")
          |> redirect(to: redirect_to)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    decision = Decisions.get_decision!(id)
    edit_decision_changeset = Decisions.change_decision(decision)
    reflection_changeset = Reflections.change_reflection(%Reflection{})
    scopes = Scopes.list_organization_scopes(conn.assigns.organization)

    draft = if decision.draft_id, do: Drafts.get_draft!(decision.draft_id), else: nil
    current_draft_users = if decision.draft_id, do: Drafts.get_draft_connected_users(draft.id), else: nil

    render(conn, "show.html",
      decision: decision,
      edit_decision_changeset: edit_decision_changeset,
      scopes: scopes,
      draft: draft,
      current_draft_users: current_draft_users,
      reflection_changeset: reflection_changeset
    )
  end

  def edit(conn, %{"id" => id}) do
    decision = Decisions.get_decision!(id)
    changeset = Decisions.change_decision(decision)
    render(conn, "edit.html", decision: decision, changeset: changeset)
  end

  def update(conn, params) do
    id = params["id"]
    decision_params = params["decision"]
    private = params["private"]
    scope = if Map.has_key?(params, "scopes"), do: params["scopes"], else: nil
    users = if Map.has_key?(params, "users"), do:  params["users"], else: nil
    date = if Map.has_key?(params, "date"), do: params["date"], else: Date.to_string(Date.utc_today)
    reflection_date = if Map.has_key?(params, "reflection_date"), do: params["reflection_date"], else: nil
    decision = Decisions.get_decision!(id)

    case Decisions.update_decision(decision, Map.merge(decision_params, %{"private" => private, "date" => date, "reflection_date" => reflection_date})) do
      {:ok, decision} ->


        Tags.delete_decision_tag_list(decision.id)
        Scopes.delete_scope_from_decision(decision.id)
        Decisions.delete_decision_users(decision.id)

        if decision_params["tag_list"] != "" do
          Tags.assign_tags_to_decision(decision_params["tag_list"], decision.id, decision.organization_id, decision.user_id)
        end

        if scope != nil do
          Scopes.assign_scopes_to_decision(scope, decision.id)
        end

        if users != nil do
          Decisions.create_decision_users(users, decision.id)
        end

        conn
        |> put_flash(:info, "Decision updated successfully.")
        |> redirect(to: Routes.decision_path(conn, :show, decision))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", decision: decision, changeset: changeset)
    end
  end


  def delete(conn, %{"id" => id}) do
    decision = Decisions.get_decision!(id)
    {:ok, _decision} = Decisions.delete_decision(decision)

    conn
    |> put_flash(:info, "Decision deleted successfully.")
    |> redirect(to: Routes.decision_path(conn, :index))
  end
end
