defmodule HistoraWeb.Draft_scopeController do
  use HistoraWeb, :controller

  alias Histora.Drafts
  alias Histora.Drafts.Draft_scope

  def index(conn, _params) do
    draft_scopes = Drafts.list_draft_scopes()
    render(conn, "index.html", draft_scopes: draft_scopes)
  end

  def new(conn, _params) do
    changeset = Drafts.change_draft_scope(%Draft_scope{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"draft_scope" => draft_scope_params}) do
    case Drafts.create_draft_scope(draft_scope_params) do
      {:ok, draft_scope} ->
        conn
        |> put_flash(:info, "Draft scope created successfully.")
        |> redirect(to: Routes.draft_scope_path(conn, :show, draft_scope))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    draft_scope = Drafts.get_draft_scope!(id)
    render(conn, "show.html", draft_scope: draft_scope)
  end

  def edit(conn, %{"id" => id}) do
    draft_scope = Drafts.get_draft_scope!(id)
    changeset = Drafts.change_draft_scope(draft_scope)
    render(conn, "edit.html", draft_scope: draft_scope, changeset: changeset)
  end

  def update(conn, %{"id" => id, "draft_scope" => draft_scope_params}) do
    draft_scope = Drafts.get_draft_scope!(id)

    case Drafts.update_draft_scope(draft_scope, draft_scope_params) do
      {:ok, draft_scope} ->
        conn
        |> put_flash(:info, "Draft scope updated successfully.")
        |> redirect(to: Routes.draft_scope_path(conn, :show, draft_scope))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", draft_scope: draft_scope, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    draft_scope = Drafts.get_draft_scope!(id)
    {:ok, _draft_scope} = Drafts.delete_draft_scope(draft_scope)

    conn
    |> put_flash(:info, "Draft scope deleted successfully.")
    |> redirect(to: Routes.draft_scope_path(conn, :index))
  end
end
