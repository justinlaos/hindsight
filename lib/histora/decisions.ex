defmodule Histora.Decisions do
  @moduledoc """
  The Decisions context.
  """

  import Ecto.Query, warn: false
  alias Histora.Repo

  alias Histora.Tags.Tag_decision
  alias Histora.Scopes
  alias Histora.Scopes.Scope
  alias Histora.Scopes.Scope_user
  alias Histora.Scopes.Scope_decision
  alias Histora.Decisions.Decision
  alias Histora.Decisions.Approval
  alias Histora.Tags.Tag

  def list_organization_decisions(organization) do
    (from r in Decision, where: r.organization_id == ^organization.id )
    |> order_by(desc: :date)
  end

  def filter_tags(decisions, params) do
    if Map.has_key?(params, "tag_list") do
      (from r in subquery(decisions),
      join: t in Tag_decision, on: r.id == t.decision_id,
      join: tt in Tag, on: tt.id == t.tag_id,
      where: tt.id == ^String.to_integer(params["tag_list"]) )
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
      join: t in Scope_decision, on: r.id == t.decision_id,
      join: tt in Scope, on: tt.id == t.scope_id,
      where: tt.id == ^filtered_team )
    else
      decisions
    end
  end

  def filter_dates(decisions, formated_start_date, formated_end_date) do
      (from r in subquery(decisions), where: r.date >= ^formated_start_date and r.date <= ^formated_end_date )
  end

  def formate_decisions(decisions, current_user) do
    scope_list = Scopes.get_user_scopes(current_user.id)

    decisions = (from r in subquery(decisions), preload: [:user, :tags, :users, :scopes])
    |> Repo.all()

    Enum.filter(decisions, fn x -> x.private == false or
      x.user_id == current_user.id or
      filter_scope(x, scope_list) == true
    end)
  end

  defp filter_scope(decision, scope_list) do
    Enum.any?(decision.scopes, fn x -> x in scope_list end)
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

  def formate_decisions_count(decisions, current_user) do
    scope_list = Scopes.get_user_scopes(current_user.id)

    decisions = (from r in subquery(decisions), preload: [:user, :tags, :users, :scopes]) |> Repo.all()

    Enum.filter(decisions, fn x -> x.private == false or
      x.user_id == current_user.id or
      filter_scope(x, scope_list) == true
    end)
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

  end

  def update_decision_approval(decision_id, approved, note) do
    Repo.get_by(Approval, decision_id: decision_id)
      |> Approval.changeset(%{"approved" => approved, "note" => note})
      |> Repo.update()

  end

  def reset_decision_approval(organization_id, user_id, decision_id) do
    (from a in Approval, where: a.decision_id == ^decision_id )|> Repo.delete_all
    Histora.Decisions.create_decision_approval(organization_id, user_id, decision_id)
  end

  def users_active_approvals(organization, current_user) do
    (from r in Approval, where: is_nil(r.approved) and r.organization_id == ^organization.id and r.user_id == ^current_user.id, preload: [decision: [:user, :tags, :users, :scopes]] )
    |> Repo.all()
  end


  @doc """
  Gets a single decision.

  Raises `Ecto.NoResultsError` if the Decision does not exist.

  ## Examples

      iex> get_decision!(123)
      %Decision{}

      iex> get_decision!(456)
      ** (Ecto.NoResultsError)

  """
  def get_decision!(id) do
    Repo.get!(Decision, id) |> Repo.preload([:user, :tags, :users, :scopes, reflections: [:user, :decisions], logs: [:user], approval: [:user]])
  end

  @doc """
  Creates a decision.

  ## Examples

      iex> create_decision(%{field: value})
      {:ok, %Decision{}}

      iex> create_decision(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_decision(attrs \\ %{}) do
    %Decision{}
    |> Decision.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a decision.

  ## Examples

      iex> update_decision(decision, %{field: new_value})
      {:ok, %Decision{}}

      iex> update_decision(decision, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_decision(%Decision{} = decision, attrs) do
    decision
    |> Decision.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a decision.

  ## Examples

      iex> delete_decision(decision)
      {:ok, %Decision{}}

      iex> delete_decision(decision)
      {:error, %Ecto.Changeset{}}

  """
  def delete_decision(%Decision{} = decision) do
    Repo.delete(decision)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking decision changes.

  ## Examples

      iex> change_decision(decision)
      %Ecto.Changeset{data: %Decision{}}

  """
  def change_decision(%Decision{} = decision, attrs \\ %{}) do
    Decision.changeset(decision, attrs)
  end

  alias Histora.Decisions.Decision_user

  @doc """
  Returns the list of decision_users.

  ## Examples

      iex> list_decision_users()
      [%Decision_user{}, ...]

  """
  def list_decision_users do
    Repo.all(Decision_user)
  end

  @doc """
  Gets a single decision_user.

  Raises `Ecto.NoResultsError` if the Decision user does not exist.

  ## Examples

      iex> get_decision_user!(123)
      %Decision_user{}

      iex> get_decision_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_decision_user!(id), do: Repo.get!(Decision_user, id)

  @doc """
  Creates a decision_user.

  ## Examples

      iex> create_decision_user(%{field: value})
      {:ok, %Decision_user{}}

      iex> create_decision_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_decision_user(attrs \\ %{}) do
    %Decision_user{}
    |> Decision_user.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a decision_user.

  ## Examples

      iex> update_decision_user(decision_user, %{field: new_value})
      {:ok, %Decision_user{}}

      iex> update_decision_user(decision_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_decision_user(%Decision_user{} = decision_user, attrs) do
    decision_user
    |> Decision_user.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a decision_user.

  ## Examples

      iex> delete_decision_user(decision_user)
      {:ok, %Decision_user{}}

      iex> delete_decision_user(decision_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_decision_user(%Decision_user{} = decision_user) do
    Repo.delete(decision_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking decision_user changes.

  ## Examples

      iex> change_decision_user(decision_user)
      %Ecto.Changeset{data: %Decision_user{}}

  """
  def change_decision_user(%Decision_user{} = decision_user, attrs \\ %{}) do
    Decision_user.changeset(decision_user, attrs)
  end

  # def connect_scope_users_to_decision(decision_id, scope_id) do
  #   for user <- Scopes.get_scope_users(scope_id) do
  #     %Decision_user{}
  #       |> Decision_user.changeset(%{"user_id" => user.id, "decision_id" => decision_id, "from_scope" => true})
  #       |> Repo.insert()
  #   end
  # end

  def delete_decision_users(decision_id) do
    Ecto.assoc(Repo.get(Decision, decision_id), :decision_users) |> Repo.delete_all
  end

  def create_decision_users(users, decision_id) do
    for user <- users |> Enum.map(&String.to_integer/1) do
      %Decision_user{}
        |> Decision_user.changeset(%{"user_id" => user, "decision_id" => decision_id})
        |> Repo.insert()
    end
  end

  def create_decision_users_from_draft(users, decision_id) do
    for user <- users do
      %Decision_user{}
        |> Decision_user.changeset(%{"user_id" => user.id, "decision_id" => decision_id})
        |> Repo.insert()
    end
  end

  def connected_users(decision_id) do
    (from ru in Decision_user, where: ru.decision_id == ^decision_id) |> Repo.all
  end

  def get_timeline_for_decision(decision_id) do
    decision = Repo.get!(Decision, decision_id) |> Repo.preload([:user, :tags, :users, :scopes, :reflections])
    pre_timeline = get_pre_timeline(decision, [])
    post_timeline = Enum.reverse(get_post_timeline(decision, []))
    pre_timeline ++ [decision | post_timeline]
  end

  defp get_pre_timeline(decision = %Histora.Decisions.Decision{}, list) when decision.reflection_id == nil, do: list
  defp get_pre_timeline(decision = %Histora.Decisions.Decision{}, list) when decision.reflection_id != nil do
    try do
      reflection = Histora.Reflections.get_reflection!(decision.reflection_id) |> Repo.preload([:user])
      get_pre_timeline(reflection, [reflection | list])
    rescue
      Ecto.NoResultsError -> list
    end
  end

  defp get_pre_timeline(reflection = %Histora.Reflections.Reflection{}, list) when reflection.decision_id == nil, do: list
  defp get_pre_timeline(reflection = %Histora.Reflections.Reflection{}, list) when reflection.decision_id != nil do
    try do
      decision = Repo.get!(Decision, reflection.decision_id) |> Repo.preload([:user, :tags, :users, :scopes])
      get_pre_timeline(decision, [decision | list])
    rescue
      Ecto.NoResultsError -> list
    end
  end

  defp get_post_timeline(decision = %Histora.Decisions.Decision{}, list) when decision.reflections == [], do: list
  defp get_post_timeline(decision = %Histora.Decisions.Decision{}, list) when decision.reflections != [] do
    try do
      reflection = Histora.Reflections.get_reflection!(List.first(decision.reflections).id) |> Repo.preload([:decisions, :user])
      get_post_timeline(reflection, [reflection | list])
    rescue
      Ecto.NoResultsError -> list
    end
  end

  defp get_post_timeline(reflection = %Histora.Reflections.Reflection{}, list) when reflection.decisions == [], do: list
  defp get_post_timeline(reflection = %Histora.Reflections.Reflection{}, list) when reflection.decisions != [] do
    try do
      decision = Repo.get!(Decision, List.first(reflection.decisions).id) |> Repo.preload([:user, :tags, :users, :scopes, :reflections])
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
