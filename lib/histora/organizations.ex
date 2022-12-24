defmodule Histora.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Histora.Repo

  alias Histora.Organizations.Organization

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations do
    Repo.all(Organization)
  end

  def update_expired_trials do
    trialing_organizations = (from o in Organization, where: o.status == "trialing" ) |> Repo.all()
    Enum.map(trialing_organizations, fn organization ->
      if Date.compare(organization.trial_expire_date, Date.utc_today) == :gt do
        Histora.Organizations.update_organization(organization, %{"status" => "trial_expired"})
        Histora.Email.trial_expired(organization.billing_email, organization)
          |> Histora.Mailer.deliver_now()
      end
    end)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
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

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{data: %Organization{}}

  """
  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end
end
