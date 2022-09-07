defmodule HistoraWeb.TagController do
  use HistoraWeb, :controller

  alias Histora.Tags
  alias Histora.Tags.Tag

  def index(conn, _params) do
    tags = Tags.list_organization_tags(conn.assigns.organization)
    Histora.Data.page(conn.assigns.current_user, "Settings Tags")
    render(conn, "index.html", settings: true, tags: tags)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Tags.get_tag!(id)

    case Tags.update_tag(tag, tag_params) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag updated successfully.")
        |> redirect(to: Routes.settings_path(conn, :tags))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tag: tag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Tags.get_tag!(id)
    {:ok, _tag} = Tags.delete_tag(tag)

    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: Routes.tag_path(conn, :index))
  end

  def favorite(conn, %{"tag" => tag}) do
    case Tags.create_tag_favorite(%{"tag_id" => tag, "user_id" => conn.assigns.current_user.id}) do
      {:ok, tag_favorite} ->
        Histora.Data.event(conn.assigns.current_user, "Favorited A Tag")
        conn
        |> redirect(to: Routes.settings_path(conn, :tags))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def unfavorite(conn, %{"tag" => tag}) do
    tag_favorite = Tags.get_tag_favorite!(tag, conn.assigns.current_user.id)
    {:ok, _tag_favorite} = Tags.delete_tag_favorite(tag_favorite)
    Histora.Data.event(conn.assigns.current_user, "Unfavorited A Tag")
    conn
    |> redirect(to: Routes.settings_path(conn, :tags))
  end
end
