defmodule HistoraWeb.Admin.SettingsController do
  use HistoraWeb, :controller

  alias Histora.Users.User
  alias Histora.Users
  alias Histora.Goals
  alias Histora.Organizations
  alias Histora.Organizations.Organization

  def convert_trial(conn, _params) do
    %{organization: organization} = conn.assigns
    managed_users = Users.get_organization_users_for_settings(organization)

    render(conn, "convert_trial.html", organization: organization, managed_users: managed_users, settings: true)
  end

  def organization(conn, _params) do
    %{organization: organization} = conn.assigns

    changeset = Organizations.change_organization(organization)
    managed_users = Users.get_organization_users_for_settings(organization)

    new_user_changeset = User.invite_changeset(%User{}, conn.assigns.current_user, %{"email" => nil})
    Histora.Data.page(conn.assigns.current_user, "Settings Organization")

    render(conn, "organization.html",
      organization: organization,
      managed_users: managed_users,
      changeset: changeset,
      new_user_changeset: new_user_changeset,
      settings: true
    )
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

  def select_plan(conn, params) do
    %{organization: organization} = conn.assigns
    redirect(conn, external: stripe_checkout_url(params["user_size"], organization.billing_email))
  end

  defp stripe_checkout_url(user_size, billing_email) do
    case user_size do
      "10" -> "https://buy.stripe.com/5kA7t5aRI2B9a9qcMM?prefilled_email=#{billing_email}"
      "15" -> "https://buy.stripe.com/bIY00DcZQ2B92GY145?prefilled_email=#{billing_email}"
      "20" -> "https://buy.stripe.com/00g7t56BsdfNchybIK?prefilled_email=#{billing_email}"
      "25" -> "https://buy.stripe.com/9AQ5kX7Fwb7FchybIL?prefilled_email=#{billing_email}"
      "30" -> "https://buy.stripe.com/dR65kX2lcdfN3L2bIM?prefilled_email=#{billing_email}"
      "35" -> "https://buy.stripe.com/5kA4gT6Bsa3B2GYdQV?prefilled_email=#{billing_email}"
      "40" -> "https://buy.stripe.com/fZeeVxcZQ3Fd81i6ou?prefilled_email=#{billing_email}"
      "45" -> "https://buy.stripe.com/bIY3cP7FwdfNchydQX?prefilled_email=#{billing_email}"
      "50" -> "https://buy.stripe.com/6oEbJl0d4grZ2GY6ow?prefilled_email=#{billing_email}"
      "60" -> "https://buy.stripe.com/7sI6p15xofnV4P66ox?prefilled_email=#{billing_email}"
      "70" -> "https://buy.stripe.com/9AQ5kX3pg2B91CU5ku?prefilled_email=#{billing_email}"
      "80" -> "https://buy.stripe.com/00g7t5e3U8Zx5Ta8wH?prefilled_email=#{billing_email}"
      "90" -> "https://buy.stripe.com/cN23cPcZQ3Fd4P65kw?prefilled_email=#{billing_email}"
      "100" -> "https://buy.stripe.com/6oE7t54tk4JhftK4gt?prefilled_email=#{billing_email}"
    end
  end
end
