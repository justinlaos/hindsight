defmodule Histora.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Histora.Repo

  alias Histora.Organizations.Organization

  def list_organizations do
    Repo.all(Organization)
  end

  def free_plan_decision_limit_reached(organization) do
    if organization.status == "free" do
      Repo.aggregate(from(r in Histora.Decisions.Decision, where: r.organization_id == ^organization.id), :count, :id) >= 50
    else
      true
    end
  end

  def run_weekly_roundup do
    organizations = (from o in Organization, where: o.status in ["active", "free"], preload: :users ) |> Repo.all()
    Enum.map(organizations, fn organization ->
      Enum.map(organization.users, fn user ->
        Histora.Email.weekly_roundup(user.email, Histora.Decisions.get_weeky_decisions_for_user(user))
        |> Histora.Mailer.deliver_now()
      end)
    end)
  end

  def get_organization!(id), do: Repo.get!(Organization, id)

  def get_organization_by_subscription_id!(id), do: Repo.get_by!(Organization, stripe_subscription_id: id)

  def get_organization_by_current_user(current_user) do
    Repo.get!(Organization, current_user.organization_id)
  end

  def get_organization_by_billing_email(email) do
    Repo.get_by(Organization, billing_email: email)
  end

  def check_if_billing_email_exists(email) do
    Repo.exists?(from o in Organization, where: o.billing_email == ^email)
  end

  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end
end
