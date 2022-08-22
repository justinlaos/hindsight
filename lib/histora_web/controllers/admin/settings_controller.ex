defmodule HistoraWeb.Admin.SettingsController do
  use HistoraWeb, :controller

  alias Histora.Users.User
  alias Histora.Users
  alias Histora.Tags
  alias Histora.Organizations
  alias Histora.Use
  alias Histora.Organizations.Organization

  def integrations(conn, _params) do
    %{organization: organization} = conn.assigns
    render(conn, "integrations.html", organization: organization, settings: true)
  end

  def tags(conn, _params) do
    tags = Tags.list_organization_tags(conn.assigns.organization)
    Histora.Data.page(conn.assigns.current_user, "Settings Tags")
    render(conn, "tags.html", settings: true, tags: tags)
  end

  def organization(conn, _params) do
    %{organization: organization} = conn.assigns

    changeset = Organizations.change_organization(organization)
    managed_users = Users.get_organization_users_for_settings(organization)
    user_favorites = Users.current_user_user_favorites(conn.assigns.current_user)

    new_user_changeset = User.invite_changeset(%User{}, conn.assigns.current_user, %{"email" => nil})
    Histora.Data.page(conn.assigns.current_user, "Settings Organization")

    render(conn, "organization.html", organization: organization, managed_users: managed_users, changeset: changeset, new_user_changeset: new_user_changeset, user_favorites: user_favorites, settings: true)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Organizations.get_organization!(id)

    case Organizations.update_organization(organization, organization_params) do
      {:ok, _organization} ->

        Histora.Data.event(conn.assigns.current_user, "Updated Organization Info")
        conn
        |> put_flash(:info, "organization updated successfully.")
        |> redirect(to: Routes.settings_path(conn, :organization))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "organization.html", organization: organization, changeset: changeset)
    end
  end

  def create_customer_portal_session(conn, %{"id" => id}) do
    {:ok, portal} = Stripe.BillingPortal.Session.create(%{:customer => id})
    Histora.Data.page(conn.assigns.current_user, "Billing")
    redirect(conn, external: portal.url)
  end
end
