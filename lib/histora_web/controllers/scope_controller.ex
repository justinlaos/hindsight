defmodule HistoraWeb.ScopeController do
  use HistoraWeb, :controller

  alias Histora.Scopes
  alias Histora.Users
  alias Histora.Scopes.Scope

  def index(conn, _params) do
    scopes = Scopes.list_organization_scopes(conn.assigns.organization)
    scope_changeset = Scopes.change_scope(%Scope{})
    users = Users.get_organization_users(conn.assigns.organization)
    render(conn, "index.html", scopes: scopes, scope_changeset: scope_changeset, users: users)
  end

  def new(conn, _params) do
    changeset = Scopes.change_scope(%Scope{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do

    scope = params["scope"]

    %{"users_list" => users_list} = params
    case Scopes.create_scope(%{"name" => scope["name"], "organization_id" => conn.assigns.organization.id}) do
      {:ok, scope} ->

        if Map.has_key?(params, "users_list") && users_list != "" do
          Scopes.create_scope_users(users_list, scope.id)
        end

        conn
        |> put_flash(:info, "Scope created successfully.")
        |> redirect(to: Routes.scope_path(conn, :show, scope))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    scope = Scopes.get_scope!(id)
    records = Scopes.get_records_for_scope(id)
    current_scope_users = Scopes.get_scope_users(id)
    users = Users.get_organization_users(conn.assigns.organization)

    changeset = Scopes.change_scope(scope)
    render(conn, "show.html", scope: scope, records: records, changeset: changeset, users: users, current_scope_users: current_scope_users)
  end

  def edit(conn, %{"id" => id}) do
    scope = Scopes.get_scope!(id)
    changeset = Scopes.change_scope(scope)
    render(conn, "edit.html", scope: scope, changeset: changeset)
  end

  def update(conn, %{"id" => id, "scope" => scope_params, "users_list" => users_list}) do
    scope = Scopes.get_scope!(id)

    case Scopes.update_scope(scope, scope_params) do
      {:ok, scope} ->

        if users_list != "" do
          Scopes.update_scope_users(users_list, scope.id)
        end

        conn
        |> put_flash(:info, "Scope updated successfully.")
        |> redirect(to: Routes.scope_path(conn, :show, scope))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", scope: scope, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    scope = Scopes.get_scope!(id)
    {:ok, _scope} = Scopes.delete_scope(scope)

    conn
    |> put_flash(:info, "Scope deleted successfully.")
    |> redirect(to: Routes.scope_path(conn, :index))
  end
end
