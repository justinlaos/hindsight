defmodule Histora.Signup do
  alias Histora.Organizations
  alias Histora.Users

  def create_organization_trial(email, password, plan, promo) do
    case Organizations.check_if_billing_email_exists(email) do
      true -> {:error, "email already exists"}
      false ->
        case create_organization(email, plan, promo) do
          {:ok, organization} -> case create_user(organization, email, password) do
            {:ok, user} -> case create_user_data(user) do
              {:ok, _user} ->
                Histora.Email.new_trial("team@histora.app", organization)
                  |> Histora.Mailer.deliver_now()
                {:ok, %{email: email, password: password}}
            end
            {:error, error} -> {:error, error}
          end
          {:error, error} -> {:error, error}
        end
    end
  end

  def create_organization(email, _plan, promo) do
    case Organizations.create_organization(%{
      "stripe_price_id" => "trialing",
      "stripe_product_id" => "trialing",
      "stripe_customer_id" => "trialing",
      "stripe_subscription_id" => "trialing",
      "billing_email" => email,
      "user_limit" => 1000,
      "promo_code" => promo,
      "trial_expire_date" => Date.utc_today,
      "name" => create_new_organization_name(email),
      "status" => "trialing"
    }) do
      {:ok, organization} -> {:ok, organization}
      {:error, error} -> {:error, error}
    end
  end

  def create_user(organization, email, password) do
    case Users.create_admin(%{"email" => email, "password" => password, "password_confirmation" => password, "role" => "admin", "organization_id" => organization.id }) do
      {:ok, user} -> {:ok, user}
      {:error, error} -> {:error, error}
    end
  end

  def create_user_data(user) do
    Users.create_user_data(%{user_id: user.id})
    Histora.Data.identify(user)
    Histora.Data.group(user)
    Histora.Data.event(user, "Subscription Created")
    {:ok, user}
  end

  defp create_new_organization_name(email) do
    [_, domain] = String.split(email, "@")
    [name, _] = String.split(domain, ".")
    if Enum.member?(["gmail", "yahoo"], name) do
      "New Organization"
    else
        name
    end
  end
end
