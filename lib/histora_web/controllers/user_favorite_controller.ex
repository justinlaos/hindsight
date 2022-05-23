defmodule HistoraWeb.User_favoriteController do
  use HistoraWeb, :controller

  alias Histora.Users
  alias Histora.Users.User_favorite

  def index(conn, _params) do
    user_favorites = Users.list_user_favorites()
    render(conn, "index.html", user_favorites: user_favorites)
  end

  def new(conn, _params) do
    changeset = Users.change_user_favorite(%User_favorite{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_favorite" => user_favorite_params}) do
    case Users.create_user_favorite(user_favorite_params) do
      {:ok, user_favorite} ->
        conn
        |> put_flash(:info, "User favorite created successfully.")
        |> redirect(to: Routes.user_favorite_path(conn, :show, user_favorite))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_favorite = Users.get_user_favorite!(id)
    render(conn, "show.html", user_favorite: user_favorite)
  end

  def edit(conn, %{"id" => id}) do
    user_favorite = Users.get_user_favorite!(id)
    changeset = Users.change_user_favorite(user_favorite)
    render(conn, "edit.html", user_favorite: user_favorite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_favorite" => user_favorite_params}) do
    user_favorite = Users.get_user_favorite!(id)

    case Users.update_user_favorite(user_favorite, user_favorite_params) do
      {:ok, user_favorite} ->
        conn
        |> put_flash(:info, "User favorite updated successfully.")
        |> redirect(to: Routes.user_favorite_path(conn, :show, user_favorite))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_favorite: user_favorite, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_favorite = Users.get_user_favorite!(id)
    {:ok, _user_favorite} = Users.delete_user_favorite(user_favorite)

    conn
    |> put_flash(:info, "User favorite deleted successfully.")
    |> redirect(to: Routes.user_favorite_path(conn, :index))
  end
end
