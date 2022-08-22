defmodule HistoraWeb.UserController do
  use HistoraWeb, :controller

  alias Histora.Users.User
  alias Histora.Users

  def index(conn, _params) do
    users = Users.get_organization_users(conn.assigns.organization)
    render(conn, "index.html", users: users)
  end

  # def new(conn, _params) do
  #   changeset = Tags.change_tag(%Tag{})
  #   render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"tag" => tag_params}) do
  #   case Tags.create_tag(tag_params) do
  #     {:ok, tag} ->
  #       conn
  #       |> put_flash(:info, "Tag created successfully.")
  #       |> redirect(to: Routes.tag_path(conn, :show, tag))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    users = Users.get_organization_users(conn.assigns.organization)
    user = Users.get_user!(id)
    decisions = Users.get_decisions_for_user(id)

    render(conn, "show.html", user: user, users: users, decisions: decisions)
  end

  # def edit(conn, %{"id" => id}) do
  #   tag = Tags.get_tag!(id)
  #   changeset = Tags.change_tag(tag)
  #   render(conn, "edit.html", tag: tag, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "tag" => tag_params}) do
  #   tag = Tags.get_tag!(id)

  #   case Tags.update_tag(tag, tag_params) do
  #     {:ok, tag} ->
  #       conn
  #       |> put_flash(:info, "Tag updated successfully.")
  #       |> redirect(to: Routes.tag_path(conn, :show, tag))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", tag: tag, changeset: changeset)
  #   end
  # end

  def favorite(conn, %{"favorite_user_id" => favorite_user_id}) do

    case Users.create_user_favorite(%{"favorite_user_id" => favorite_user_id, "user_id" => conn.assigns.current_user.id}) do
      {:ok, user_favorite} ->
        Histora.Data.event(conn.assigns.current_user, "Favorited A User")
        conn
        |> redirect(to: Routes.settings_path(conn, :organization))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def unfavorite(conn, %{"favorite_user_id" => favorite_user_id}) do
    user_favorite = Users.get_user_favorite!(favorite_user_id, conn.assigns.current_user.id)
    {:ok, _user_favorite} = Users.delete_user_favorite(user_favorite)
    Histora.Data.event(conn.assigns.current_user, "Unfavorited A User")
    conn
    |> redirect(to: Routes.settings_path(conn, :organization))
  end
end
