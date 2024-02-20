defmodule Histora.Signup do
  alias Histora.Organizations
  alias Histora.Users

  def create_organization(email, password, promo) do
    case check_signup_info(email, password) do
      false -> {:error, "incorrect account info. please add a valid email and password of at least 6 characters"}
      true ->
        case Organizations.check_if_billing_email_exists(email) do
          true -> {:error, "email already exists"}
          false ->
            case create_organization(email, promo) do
              {:ok, organization} -> case create_user(organization, email, password) do
                {:ok, user} -> case create_user_data(user) do
                  {:ok, user} ->
                    create_starting_data(organization, user)
                    Histora.Email.new_trial("team@histora.app", organization, promo)
                      |> Histora.Mailer.deliver_now()
                    {:ok, %{email: email, password: password}}
                end
                {:error, error} -> {:error, error}
              end
              {:error, error} -> {:error, error}
            end
        end
    end
  end

  def check_signup_info(email, password) do
    if String.length(email) <= 5 || String.contains?(email, "@") == false || String.length(password) <= 6  do
      false
    else
      true
    end
  end

  def create_organization(email, promo) do
    case Organizations.create_organization(%{
      "stripe_price_id" => "free",
      "stripe_product_id" => "free",
      "stripe_customer_id" => "free",
      "stripe_subscription_id" => "free",
      "billing_email" => email,
      "user_limit" => 10,
      "promo_code" => promo,
      "name" => create_new_organization_name(email),
      "status" => "free"
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

  def create_starting_data(organization, user) do
    {:ok, team} = %Histora.Teams.Team{} |> Histora.Teams.Team.changeset(%{"name" => "Management", "organization_id" => organization.id, "private" => false}) |> Histora.Repo.insert()
    {:ok, goal_one} = %Histora.Goals.Goal{} |> Histora.Goals.Goal.changeset(%{"name" => "Increase Revenue", "organization_id" => organization.id, "user_id" => user.id}) |> Histora.Repo.insert()
    {:ok, goal_two} = %Histora.Goals.Goal{} |> Histora.Goals.Goal.changeset(%{"name" => "Lower Turnover", "organization_id" => organization.id, "user_id" => user.id}) |> Histora.Repo.insert()

    {:ok, decision} = %Histora.Decisions.Decision{}
      |> Histora.Decisions.Decision.changeset(%{
        "organization_id" => organization.id,
        "user_id" => user.id,
        "what" => "Leverage Histora to help us steer our team in the right direction.",
        "why" => "With Histora we can stay informed, know what works, and avoid mistakes. We hope this will help us make informed decisions that lead to success and avoid those that do not.",
        "reference" => "https://www.gohindsight.com",
        "date" => Date.to_string(Date.utc_today),
        "reflection_date" => Date.to_string(Date.add(Date.utc_today, 14))
      }) |> Histora.Repo.insert()

      Histora.Logs.create_log(%{"organization_id" => organization.id, "decision_id" => decision.id, "user_id" => user.id, "event" => "created a decision"})
      Histora.Teams.create_team_decision(%{"team_id" => team.id, "decision_id" => decision.id})
      Histora.Goals.create_goal_decision(%{"goal_id" => goal_one.id, "decision_id" => decision.id})
      Histora.Goals.create_goal_decision(%{"goal_id" => goal_two.id, "decision_id" => decision.id})
      %Histora.Teams.Team_user{} |> Histora.Teams.Team_user.changeset(%{"user_id" => user.id, "team_id" => team.id}) |> Histora.Repo.insert()
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
