defmodule HistoraWeb.OrganizationController do
  use HistoraWeb, :controller

  alias Histora.Users.User
  alias Histora.Users
  alias Histora.Organizations

  def index(conn, _params) do
    %{organization: organization} = conn.assigns
    Histora.Data.page(conn.assigns.current_user, "Organization Index")

    render(conn, "index.html",
      organization: organization,
      managed_users: Users.get_organization_users_for_settings(organization),
      changeset: Organizations.change_organization(organization),
      new_user_changeset: User.invite_changeset(%User{}, conn.assigns.current_user, %{"email" => nil}),
      settings: true
    )
  end
end
