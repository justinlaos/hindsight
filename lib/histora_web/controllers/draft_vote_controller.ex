defmodule HistoraWeb.Draft_voteController do
  use HistoraWeb, :controller

  alias Histora.Drafts
  alias Histora.Drafts.Draft_vote

  def index(conn, _params) do
    draft_votes = Drafts.list_draft_votes()
    render(conn, "index.html", draft_votes: draft_votes)
  end

  def new(conn, _params) do
    changeset = Drafts.change_draft_vote(%Draft_vote{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    draft_option = Drafts.get_draft_option!(params["option"])

    Drafts.delete_other_votes_for_draft(conn.assigns.current_user.id, draft_option.draft_id)
    case Drafts.create_draft_vote(%{"user_id" => conn.assigns.current_user.id, "draft_option_id" => draft_option.id, "draft_id" => draft_option.draft_id}) do

      {:ok, draft_vote} ->

        Histora.Logs.create_log(%{
          "organization_id" => conn.assigns.organization.id,
          "draft_id" => draft_vote.draft_id,
          "user_id" => conn.assigns.current_user.id,
          "event" => "voted on a draft option" })

        conn
        |> put_flash(:info, "vote was casted")
        |> redirect(to: Routes.draft_path(conn, :show, draft_option.draft_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    draft_vote = Drafts.get_draft_vote!(id)
    render(conn, "show.html", draft_vote: draft_vote)
  end

  def edit(conn, %{"id" => id}) do
    draft_vote = Drafts.get_draft_vote!(id)
    changeset = Drafts.change_draft_vote(draft_vote)
    render(conn, "edit.html", draft_vote: draft_vote, changeset: changeset)
  end

  def update(conn, %{"id" => id, "draft_vote" => draft_vote_params}) do
    draft_vote = Drafts.get_draft_vote!(id)

    case Drafts.update_draft_vote(draft_vote, draft_vote_params) do
      {:ok, draft_vote} ->
        conn
        |> put_flash(:info, "Draft vote updated successfully.")
        |> redirect(to: Routes.draft_vote_path(conn, :show, draft_vote))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", draft_vote: draft_vote, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    draft_vote = Drafts.get_draft_vote!(id)
    {:ok, _draft_vote} = Drafts.delete_draft_vote(draft_vote)

    conn
    |> put_flash(:info, "Draft vote deleted successfully.")
    |> redirect(to: Routes.draft_vote_path(conn, :index))
  end
end
