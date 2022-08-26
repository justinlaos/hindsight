defmodule HistoraWeb.User_dataController do
  use HistoraWeb, :controller

  alias Histora.Users
  alias Histora.Users.User_data

  def index(conn, _params) do
    user_data = Users.list_user_data()
    render(conn, "index.html", user_data: user_data)
  end

  def new(conn, _params) do
    changeset = Users.change_user_data(%User_data{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_data" => user_data_params}) do
    case Users.create_user_data(user_data_params) do
      {:ok, user_data} ->
        conn
        |> put_flash(:info, "User data created successfully.")
        |> redirect(to: Routes.user_data_path(conn, :show, user_data))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_data = Users.get_user_data!(id)
    render(conn, "show.html", user_data: user_data)
  end

  def edit(conn, %{"id" => id}) do
    user_data = Users.get_user_data!(id)
    changeset = Users.change_user_data(user_data)
    render(conn, "edit.html", user_data: user_data, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_data" => user_data_params}) do
    user_data = Users.get_user_data!(id)

    case Users.update_user_data(user_data, user_data_params) do
      {:ok, user_data} ->
        conn
        |> put_flash(:info, "User data updated successfully.")
        |> redirect(to: Routes.user_data_path(conn, :show, user_data))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_data: user_data, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_data = Users.get_user_data!(id)
    {:ok, _user_data} = Users.delete_user_data(user_data)

    conn
    |> put_flash(:info, "User data deleted successfully.")
    |> redirect(to: Routes.user_data_path(conn, :index))
  end
end
