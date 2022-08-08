defmodule HistoraWeb.DraftController do
  use HistoraWeb, :controller

  alias Histora.Drafts
  alias Histora.Drafts.Draft
  alias Histora.Drafts.Draft_option
  alias Histora.Tags
  alias Histora.Users
  alias Histora.Decisions
  alias Histora.Scopes
  alias Histora.Decisions.Decision

  def index(conn, _params) do
    your_drafts = Drafts.list_your_drafts(conn.assigns.current_user.id, conn.assigns.organization.id)
    scope_drafts = Drafts.list_scope_drafts(conn.assigns.current_user.id, conn.assigns.organization.id)
    connected_drafts = Drafts.list_connected_drafts(conn.assigns.current_user.id, conn.assigns.organization.id)
    draft_changeset = Drafts.change_draft(%Draft{})
    render(conn, "index.html", your_drafts: your_drafts, scope_drafts: scope_drafts, connected_drafts: connected_drafts, draft_changeset: draft_changeset)
  end

  def convert(conn, params) do
    decision = params["decision"]

    tag_list = if Map.has_key?(decision, "tag_list"), do: decision["tag_list"], else: ""
    scopes = Drafts.get_draft_scopes(params["draft"])
    users = Drafts.get_draft_connected_users(params["draft"])
    draft = Drafts.get_draft!(params["draft"])
    date = if Map.has_key?(params, "date"), do: params["date"], else: Date.to_string(Date.utc_today)

    case Drafts.convert_draft(params["draft"], conn.assigns.current_user.id, params["decision"], date) do
      {:ok, decision} ->

        if tag_list != "" do
          Tags.assign_tags_to_decision(tag_list, decision.id, decision.organization_id, decision.user_id)
        end

        if scopes != nil do
          Scopes.assign_scopes_from_draft_to_decision(scopes, decision.id)
        end

        if users != nil do
          Decisions.create_decision_users_from_draft(users, decision.id)
        end

        case Drafts.update_draft(draft, %{"converted" => true}) do
          {:ok, draft} ->
            conn
              |> put_flash(:info, "Draft converted to new decision")
              |> redirect(to: Routes.decision_path(conn, :show, decision))
          {:error, error} -> IO.inspect(error)
        end
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def new(conn, _params) do
    changeset = Drafts.change_draft(%Draft{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    draft = params["draft"]

    target_date = if Map.has_key?(params, "target_date"), do: params["target_date"], else: ""
    users_list = if Map.has_key?(params, "users_list"), do: params["users_list"], else: ""
    scopes = if Map.has_key?(params, "new_draft_scopes"), do: params["new_draft_scopes"], else: ""

    case Drafts.create_draft(%{"title" => draft["title"], "description" => draft["description"], "reference" => draft["reference"], "target_date" => target_date, "user_id" => conn.assigns.current_user.id, "organization_id" => conn.assigns.organization.id}) do
      {:ok, draft} ->

        if Map.has_key?(params, "users_list") && users_list != "" do
          Drafts.create_draft_users(users_list, draft.id)
        end

        if scopes != nil do
          Drafts.assign_scopes_to_draft(scopes, draft.id)
        end

        conn
        |> put_flash(:info, "Draft created successfully.")
        |> redirect(to: Routes.draft_path(conn, :show, draft))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Issue Creating Draft.")
        |> redirect(to: Routes.draft_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    draft = Drafts.get_draft!(id)
    changeset = Drafts.change_draft(draft)
    current_draft_users = Drafts.get_draft_connected_users(draft.id)
    draft_option_changeset = Drafts.change_draft_option(%Draft_option{})

    render(conn, "show.html", draft: draft, changeset: changeset, current_draft_users: current_draft_users, draft_option_changeset: draft_option_changeset)
  end

  def edit(conn, %{"id" => id}) do
    draft = Drafts.get_draft!(id)
    changeset = Drafts.change_draft(draft)
    render(conn, "edit.html", draft: draft, changeset: changeset)
  end

  def update(conn, params) do
    id = params["id"]
    draft_params = params["draft"]

    target_date = if Map.has_key?(params, "target_date"), do: params["target_date"], else: ""
    scopes = if Map.has_key?(params, "scopes"), do: params["scopes"], else: nil
    users = if Map.has_key?(params, "users"), do:  params["users"], else: nil
    draft = Drafts.get_draft!(id)

    case Drafts.update_draft(draft, Map.merge(draft_params, %{"target_date" => target_date})) do
      {:ok, draft} ->

        Drafts.delete_scopes_from_draft(draft.id)
        Drafts.delete_draft_users(draft.id)

        if scopes != nil do
          Drafts.assign_scopes_to_draft(scopes, draft.id)
        end

        if users != nil do
          Drafts.create_draft_users(users, draft.id)
        end

        conn
        |> put_flash(:info, "Draft updated successfully.")
        |> redirect(to: Routes.draft_path(conn, :show, draft))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", draft: draft, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    draft = Drafts.get_draft!(id)
    {:ok, _draft} = Drafts.delete_draft(draft)

    conn
    |> put_flash(:info, "Draft deleted successfully.")
    |> redirect(to: Routes.draft_path(conn, :index))
  end
end
