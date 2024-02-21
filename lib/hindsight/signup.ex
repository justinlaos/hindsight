defmodule Hindsight.Signup do
  alias Hindsight.Organizations
  alias Hindsight.Users

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
                    Hindsight.Email.new_trial("team@hindsight.app", organization, promo)
                      |> Hindsight.Mailer.deliver_now()
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
    Hindsight.Data.identify(user)
    Hindsight.Data.group(user)
    Hindsight.Data.event(user, "Subscription Created")
    {:ok, user}
  end

  def create_starting_data(organization, user) do
    {:ok, team} = %Hindsight.Teams.Team{} |> Hindsight.Teams.Team.changeset(%{"name" => "Management", "organization_id" => organization.id, "private" => false}) |> Hindsight.Repo.insert()
    {:ok, goal_one} = %Hindsight.Goals.Goal{} |> Hindsight.Goals.Goal.changeset(%{"name" => "Increase Revenue", "organization_id" => organization.id, "user_id" => user.id}) |> Hindsight.Repo.insert()
    {:ok, goal_two} = %Hindsight.Goals.Goal{} |> Hindsight.Goals.Goal.changeset(%{"name" => "Lower Turnover", "organization_id" => organization.id, "user_id" => user.id}) |> Hindsight.Repo.insert()

    {:ok, decision} = %Hindsight.Decisions.Decision{}
      |> Hindsight.Decisions.Decision.changeset(%{
        "organization_id" => organization.id,
        "user_id" => user.id,
        "what" => "Leverage Hindsight to help us steer our team in the right direction.",
        "why" => "With Hindsight we can stay informed, know what works, and avoid mistakes. We hope this will help us make informed decisions that lead to success and avoid those that do not.",
        "reference" => "https://www.gohindsight.com",
        "date" => Date.to_string(Date.utc_today),
        "reflection_date" => Date.to_string(Date.add(Date.utc_today, 14))
      }) |> Hindsight.Repo.insert()

      Hindsight.Logs.create_log(%{"organization_id" => organization.id, "decision_id" => decision.id, "user_id" => user.id, "event" => "created a decision"})
      Hindsight.Teams.create_team_decision(%{"team_id" => team.id, "decision_id" => decision.id})
      Hindsight.Goals.create_goal_decision(%{"goal_id" => goal_one.id, "decision_id" => decision.id})
      Hindsight.Goals.create_goal_decision(%{"goal_id" => goal_two.id, "decision_id" => decision.id})
      %Hindsight.Teams.Team_user{} |> Hindsight.Teams.Team_user.changeset(%{"user_id" => user.id, "team_id" => team.id}) |> Hindsight.Repo.insert()
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
