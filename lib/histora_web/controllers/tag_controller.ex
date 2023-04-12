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
end
