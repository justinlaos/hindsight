defmodule Hindsight.Goals do
  @moduledoc """
  The Goals context.
  """

  import Ecto.Query, warn: false

  alias Hindsight.Repo
  alias Hindsight.Goals.Goal
  alias Hindsight.Goals.Goal_decision
  alias Hindsight.Decisions.Decision

  def list_organization_goals(organization) do
    (from t in Goal,
      where: t.organization_id == ^organization.id,
      preload: [:decisions],
      order_by: [desc: (t.id)],
      group_by: t.id,
      select: t
    )
    |> Repo.all()
  end

  def list_organization_goals_for_decisions(organization_id) do
    (from t in Goal,
      where: t.organization_id == ^organization_id,
      order_by: [desc: (t.id)],
      group_by: t.id,
      select: t
    )
    |> Repo.all()
  end


  def selected_filtered_goals(organization, goal_list) do
    (from t in Goal,
      where: t.organization_id == ^organization.id,
      where: t.id == ^String.to_integer(goal_list)
    )
    |> Repo.all()
  end

  def list_organization_goals_with_2_decisions(organization) do
    (from t in Goal, where: t.organization_id == ^organization.id)
      |> Repo.all()
      |> Repo.preload(decisions: from(r in Decision, order_by: [desc: r.inserted_at], preload: [:goals, :user]))

  end

  def delete_decision_goal_list(decision_id) do
    Ecto.assoc(Repo.get(Decision, decision_id), :goal_decisions) |> Repo.delete_all
  end

  def assign_goals_to_decision(goals, decision_id) do
    for goal_id <- goals do
      case Repo.get(Goal, String.to_integer(goal_id)) do
        nil -> {:error}
        goal ->
          create_goal_decision(%{"goal_id" => goal.id, "decision_id" => decision_id})
      end
    end
  end

  @doc """
  Gets a single goal.

  Raises `Ecto.NoResultsError` if the Goal does not exist.

  ## Examples

      iex> get_goal!(123)
      %Goal{}

      iex> get_goal!(456)
      ** (Ecto.NoResultsError)

  """


  def get_goal!(id) do
    Repo.get!(Goal, id)
  end

  def get_decisions_for_goal(params) do
    if Map.has_key?(params, "filter") do
      if params["filter"] == "no_status" do
        decisions = Ecto.assoc(Repo.get(Goal, params["id"]), :decisions)
        (from d in decisions, where: fragment("NOT EXISTS (SELECT * FROM reflection_goals h WHERE h.decision_id = ?)", d.id))
      else
        reflection_goals = Ecto.assoc(Repo.get(Goal, params["id"]), :reflection_goals)
        from rg in reflection_goals,
          where: rg.achieved == ^params["filter"],
          join: d in assoc(rg, :decision),
          select: d
      end
    else
      Ecto.assoc(Repo.get(Goal, params["id"]), :decisions)
    end
  end

  def goal_percentage(goal, status) do

    status_count = Repo.aggregate(from(r in Hindsight.Reflections.Reflection_goal, where: r.goal_id == ^goal and r.achieved == ^status), :count, :id)
    goal_count = Repo.aggregate(from(r in Hindsight.Reflections.Reflection_goal, where: r.goal_id == ^goal), :count, :id)

    if status_count == 0 && goal_count == 0 do
      0
    else
      (status_count / goal_count) * 100
      |> trunc()
    end
  end

  def goals_percentage(organization, status) do

    status_count = Repo.aggregate(from(r in Hindsight.Reflections.Reflection_goal, where: r.organization_id == ^organization.id and r.achieved == ^status), :count, :id)
    organization_count = Repo.aggregate(from(r in Hindsight.Reflections.Reflection_goal, where: r.organization_id == ^organization.id), :count, :id)

    if status_count == 0 && organization_count == 0 do
      0
    else
      (status_count / organization_count) * 100
      |> trunc()
    end
  end

  # def filter_by_achieved(decisions, params) do
  #   if Map.has_key?(params, "filter") do
  #     from c in query, where: c.achieved == ^params["filter"]
  #   else
  #     query
  #   end
  # end

  defp formate_time_stamp(date) do
    case Timex.format({date.year, date.month, date.day}, "{Mfull} {D}, {YYYY}") do
      {:ok, date} -> date
      {:error, message} -> message
    end
  end

  def create_goal(attrs \\ %{}) do
    cleaned_goal = (attrs["name"] |> String.downcase(:ascii) |> String.trim(" "))
    case Repo.exists?((from s in Goal, where: s.organization_id == ^attrs["organization_id"] and s.name == ^cleaned_goal )) do
      false -> %Goal{} |> Goal.changeset(Map.merge(attrs, %{"name" => cleaned_goal})) |> Repo.insert()
      true -> {:error, "Goal already exists."}
    end
  end

  def update_goal(%Goal{} = goal, attrs) do
    goal
    |> Goal.changeset(attrs)
    |> Repo.update()
  end

  def delete_goal(%Goal{} = goal) do
    Repo.delete(goal)
  end

  def change_goal(%Goal{} = goal, attrs \\ %{}) do
    Goal.changeset(goal, attrs)
  end

  def get_goal_decision!(id), do: Repo.get!(Goal_decision, id)

  def create_goal_decision(attrs \\ %{}) do
    %Goal_decision{}
    |> Goal_decision.changeset(attrs)
    |> Repo.insert()
  end

  def update_goal_decision(%Goal_decision{} = tag_decision, attrs) do
    tag_decision
    |> Goal_decision.changeset(attrs)
    |> Repo.update()
  end

  def delete_goal_decision(%Goal_decision{} = tag_decision) do
    Repo.delete(tag_decision)
  end

  def change_goal_decision(%Goal_decision{} = tag_decision, attrs \\ %{}) do
    Goal_decision.changeset(tag_decision, attrs)
  end
end
