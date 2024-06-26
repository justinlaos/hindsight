defmodule Hindsight.Decisions do
  import Ecto.Query, warn: false
  alias Hindsight.Repo

  alias Hindsight.Goals.Goal_decision
  alias Hindsight.Teams
  alias Hindsight.Teams.Team
  alias Hindsight.Teams.Team_decision
  alias Hindsight.Decisions.Decision
  alias Hindsight.Decisions.Approval
  alias Hindsight.Goals.Goal

  def list_organization_decisions(organization) do
    (from r in Decision, where: r.organization_id == ^organization.id )
    |> order_by(desc: :date)
  end

  def filter_goals(decisions, params) do
    if Map.has_key?(params, "goal_list") do
      (from r in subquery(decisions),
      join: t in Goal_decision, on: r.id == t.decision_id,
      join: tt in Goal, on: tt.id == t.goal_id,
      where: tt.id == ^String.to_integer(params["goal_list"]) )
    else
      decisions
    end
  end

  def organization_decision_count(organization) do
    Repo.aggregate(from(r in Decision, where: r.organization_id == ^organization.id), :count, :id)
  end

  def filter_users(decisions, params) do
    if Map.has_key?(params, "users") do
      (from r in subquery(decisions),
      where: r.user_id == ^String.to_integer(params["users"]) )
    else
      decisions
    end
  end

  def filter_teams(decisions, params) do
    if Map.has_key?(params, "teams") do
      filtered_team = String.to_integer(params["teams"])
      (from r in subquery(decisions),
      join: t in Team_decision, on: r.id == t.decision_id,
      join: tt in Team, on: tt.id == t.team_id,
      where: tt.id == ^filtered_team )
    else
      decisions
    end
  end

  def filter_date(decisions, params) do
    if Map.has_key?(params, "date") and params["date"] != "" do
      (from r in subquery(decisions), where: r.date == ^params["date"])
    else
      decisions
    end
  end

  def filter_search_term(decisions, params) do
    if Map.has_key?(params, "search_term") and params["search_term"] != "" do
      search_str = params["search_term"]
        |> String.split(" ")
        |> Enum.intersperse("%")
        |> Enum.join()
        |> then(&"%#{&1}%")

      from(r in Decision, where: ilike(fragment("CONCAT((?), ' ',(?))", r.why, r.what), ^search_str), order_by: [desc: r.date] )
    else
      decisions
    end
  end

  def formate_decisions(decisions, current_user) do
    team_list = Teams.get_user_teams(current_user.id)
    decisions = (from r in subquery(decisions), preload: [:user, :goals, :teams, :reflections, reflection_goals: [:goal]]) |> Repo.all()
    if Hindsight.Users.is_admin?(current_user) do
      decisions
    else
      Enum.filter(decisions, fn x -> Enum.empty?(x.teams) or List.first(x.teams).private == false or filter_team(x, team_list) == true end)
    end
  end

  defp filter_team(decision, team_list) do
    Enum.any?(decision.teams, fn x -> (x in team_list) end)
  end

  def get_param_start_date(params) do
    [date_range] = params["dates"]
    [start_date, _end_date] = String.split(date_range, " to ")

    {:ok, formated_start_date} = NaiveDateTime.new Date.from_iso8601!(start_date), ~T[00:00:00]
    formated_start_date
  end

  def get_param_end_date(params) do
    [date_range] = params["dates"]
    [_start_date, end_date] = String.split(date_range, " to ")

    {:ok, formated_end_date} = NaiveDateTime.new Date.from_iso8601!(end_date), ~T[23:59:59]
    formated_end_date
  end

  def formate_decisions_count(organization_id) do
    Repo.aggregate(from(r in Decision, where: r.organization_id == ^organization_id), :count, :id)
  end

  def create_decision_approval(organization_id, user_id, decision_id) do
    existing_approval = Repo.get_by(Approval, decision_id: decision_id)

    if existing_approval == nil do
      %Approval{}
        |> Approval.changeset(%{"user_id" => user_id, "decision_id" => decision_id, "organization_id" => organization_id })
        |> Repo.insert()
    else
      update_approval(existing_approval, %{"user_id" => user_id})
    end

    Hindsight.Email.request_approval(Hindsight.Users.get_user!(user_id), get_decision!(decision_id))
      |> Hindsight.Mailer.deliver_now()

  end

  def update_decision_approval(decision_id, approved, note) do
    Repo.get_by(Approval, decision_id: decision_id)
      |> Approval.changeset(%{"approved" => approved, "note" => note})
      |> Repo.update()

    approval = Repo.get_by(Approval, decision_id: decision_id) |> Repo.preload([:user, decision: [:user, :goals, :teams]])

    Hindsight.Email.request_approval_response(approval)
      |> Hindsight.Mailer.deliver_now()
  end

  def reset_decision_approval(organization_id, user_id, decision_id) do
    (from a in Approval, where: a.decision_id == ^decision_id )|> Repo.delete_all
    Hindsight.Decisions.create_decision_approval(organization_id, user_id, decision_id)
  end

  def users_active_approvals(organization, current_user) do
    (from r in Approval, where: is_nil(r.approved) and r.organization_id == ^organization.id and r.user_id == ^current_user.id, preload: [decision: [:user, :goals, :teams, reflection_goals: [:goal]]] )
    |> Repo.all()
  end

  def get_weeky_decisions_for_user(user) do
    (Repo.all Ecto.assoc(Repo.get(Hindsight.Users.User, user.id), :teams))
    |> Repo.preload(decisions: from(r in Decision, where: r.date > ago(7, "day"),
      order_by: [desc: r.inserted_at], preload: [:user, :goals, :teams]))
  end

  def get_decision!(id) do
    Repo.get!(Decision, id) |> Repo.preload([:user, :goals, :teams, reflection_goals: [:goal], reflections: [:user, :decisions], logs: [:user], approval: [:user]])
  end

  def create_decision(attrs \\ %{}) do
    %Decision{}
    |> Decision.changeset(attrs)
    |> Repo.insert()
  end

  def update_decision(%Decision{} = decision, attrs) do
    decision
    |> Decision.changeset(attrs)
    |> Repo.update()
  end

  def delete_decision(%Decision{} = decision) do
    Repo.delete(decision)
  end

  def change_decision(%Decision{} = decision, attrs \\ %{}) do
    Decision.changeset(decision, attrs)
  end

  def get_timeline_for_decision(decision_id) do
    decision = Repo.get!(Decision, decision_id) |> Repo.preload([:user, :goals, :teams, :reflections, reflection_goals: [:goal]])
    pre_timeline = get_pre_timeline(decision, [])
    post_timeline = Enum.reverse(get_post_timeline(decision, []))
    pre_timeline ++ [decision | post_timeline]
  end

  defp get_pre_timeline(decision = %Hindsight.Decisions.Decision{}, list) when decision.reflection_id == nil, do: list
  defp get_pre_timeline(decision = %Hindsight.Decisions.Decision{}, list) when decision.reflection_id != nil do
    try do
      reflection = Hindsight.Reflections.get_reflection!(decision.reflection_id) |> Repo.preload([:user])
      get_pre_timeline(reflection, [reflection | list])
    rescue
      Ecto.NoResultsError -> list
    end
  end

  defp get_pre_timeline(reflection = %Hindsight.Reflections.Reflection{}, list) when reflection.decision_id == nil, do: list
  defp get_pre_timeline(reflection = %Hindsight.Reflections.Reflection{}, list) when reflection.decision_id != nil do
    try do
      decision = Repo.get!(Decision, reflection.decision_id) |> Repo.preload([:user, :goals, :teams, reflection_goals: [:goal]])
      get_pre_timeline(decision, [decision | list])
    rescue
      Ecto.NoResultsError -> list
    end
  end

  defp get_post_timeline(decision = %Hindsight.Decisions.Decision{}, list) when decision.reflections == [], do: list
  defp get_post_timeline(decision = %Hindsight.Decisions.Decision{}, list) when decision.reflections != [] do
    try do
      reflection = Hindsight.Reflections.get_reflection!(List.first(decision.reflections).id) |> Repo.preload([:decisions, :user])
      get_post_timeline(reflection, [reflection | list])
    rescue
      Ecto.NoResultsError -> list
    end
  end

  defp get_post_timeline(reflection = %Hindsight.Reflections.Reflection{}, list) when reflection.decisions == [], do: list
  defp get_post_timeline(reflection = %Hindsight.Reflections.Reflection{}, list) when reflection.decisions != [] do
    try do
      decision = Repo.get!(Decision, List.first(reflection.decisions).id) |> Repo.preload([:user, :goals, :teams, :reflections, reflection_goals: [:goal]])
      get_post_timeline(decision, [decision | list])
    rescue
      Ecto.NoResultsError -> list
    end
  end

  def update_approval(%Approval{} = approval, attrs) do
    approval
    |> Approval.changeset(attrs)
    |> Repo.update()
  end

  def change_approval(%Approval{} = approval, attrs \\ %{}) do
    Approval.changeset(approval, attrs)
  end
end
