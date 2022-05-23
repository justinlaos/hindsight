defmodule HistoraWeb.Admin.SettingsController do
  use HistoraWeb, :controller

  def organization(conn, _params) do
    %{organization: organization} = conn.assigns
    render(conn, "organization.html", organization: organization, settings: true)
  end

  def integrations(conn, _params) do
    %{organization: organization} = conn.assigns
    render(conn, "integrations.html", organization: organization, settings: true)
  end

  def manage_team(conn, _params) do
    %{organization: organization} = conn.assigns
    render(conn, "manage_team.html", organization: organization, settings: true)
  end

  def create_customer_portal_session(conn, %{"id" => id}) do
    {:ok, portal} = Stripe.BillingPortal.Session.create(%{:customer => id})
    redirect(conn, external: portal.url)
  end
end
