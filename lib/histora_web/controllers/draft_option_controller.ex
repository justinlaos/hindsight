defmodule HistoraWeb.Draft_optionController do
  use HistoraWeb, :controller

  alias Histora.Drafts
  alias Histora.Drafts.Draft_option

  def index(conn, _params) do
    draft_options = Drafts.list_draft_options()
    render(conn, "index.html", draft_options: draft_options)
  end

  def new(conn, _params) do
    changeset = Drafts.change_draft_option(%Draft_option{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"draft_option" => draft_option_params}) do
    case Drafts.create_draft_option(Map.merge(draft_option_params, %{"user_id" => conn.assigns.current_user.id})) do
      {:ok, draft_option} ->
        conn
        |> put_flash(:info, "Option created successfully.")
        |> redirect(to: Routes.draft_path(conn, :show, draft_option.draft_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    draft_option = Drafts.get_draft_option!(id)
    render(conn, "show.html", draft_option: draft_option)
  end

  def edit(conn, %{"id" => id}) do
    draft_option = Drafts.get_draft_option!(id)
    changeset = Drafts.change_draft_option(draft_option)
    render(conn, "edit.html", draft_option: draft_option, changeset: changeset)
  end

  def update(conn, %{"id" => id, "draft_option" => draft_option_params}) do
    draft_option = Drafts.get_draft_option!(id)

    case Drafts.update_draft_option(draft_option, draft_option_params) do
      {:ok, draft_option} ->
        conn
        |> put_flash(:info, "Draft option updated successfully.")
        |> redirect(to: Routes.draft_option_path(conn, :show, draft_option))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", draft_option: draft_option, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    draft_option = Drafts.get_draft_option!(id)
    {:ok, _draft_option} = Drafts.delete_draft_option(draft_option)

    conn
    |> put_flash(:info, "Draft option deleted successfully.")
    |> redirect(to: Routes.draft_option_path(conn, :index))
  end
end
