defmodule HistoraWeb.Draft_userController do
  use HistoraWeb, :controller

  alias Histora.Drafts
  alias Histora.Drafts.Draft_user

  def index(conn, _params) do
    draft_users = Drafts.list_draft_users()
    render(conn, "index.html", draft_users: draft_users)
  end

  def new(conn, _params) do
    changeset = Drafts.change_draft_user(%Draft_user{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"draft_user" => draft_user_params}) do
    case Drafts.create_draft_user(draft_user_params) do
      {:ok, draft_user} ->
        conn
        |> put_flash(:info, "Draft user created successfully.")
        |> redirect(to: Routes.draft_user_path(conn, :show, draft_user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    draft_user = Drafts.get_draft_user!(id)
    render(conn, "show.html", draft_user: draft_user)
  end

  def edit(conn, %{"id" => id}) do
    draft_user = Drafts.get_draft_user!(id)
    changeset = Drafts.change_draft_user(draft_user)
    render(conn, "edit.html", draft_user: draft_user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "draft_user" => draft_user_params}) do
    draft_user = Drafts.get_draft_user!(id)

    case Drafts.update_draft_user(draft_user, draft_user_params) do
      {:ok, draft_user} ->
        conn
        |> put_flash(:info, "Draft user updated successfully.")
        |> redirect(to: Routes.draft_user_path(conn, :show, draft_user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", draft_user: draft_user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    draft_user = Drafts.get_draft_user!(id)
    {:ok, _draft_user} = Drafts.delete_draft_user(draft_user)

    conn
    |> put_flash(:info, "Draft user deleted successfully.")
    |> redirect(to: Routes.draft_user_path(conn, :index))
  end
end
