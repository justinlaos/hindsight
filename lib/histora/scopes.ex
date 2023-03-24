defmodule Histora.Scopes do
  @moduledoc """
  The Scopes context.
  """

  import Ecto.Query, warn: false
  alias Histora.Repo

  alias Histora.Scopes.Scope
  alias Histora.Users.User
  alias Histora.Decisions
  alias Histora.Decisions.Decision
  alias Histora.Decisions.Decision_user
  alias Histora.Scopes.Scope_user

  @doc """
  Returns the list of scopes.

  ## Examples

      iex> list_scopes()
      [%Scope{}, ...]

  """
  def list_scopes do
    Repo.all(Scope)
  end

  def list_organization_scopes(organization, current_user) do
    if current_user.role == "admin" do
      (from s in Scope, where: s.organization_id == ^organization.id, preload: [:users, :decisions] ) |> Repo.all()
    else
      user_scope = (from su in Scope_user, where: su.user_id == ^current_user.id, select: su.scope_id) |> Repo.all()
      (from s in Scope,
        where: s.organization_id == ^organization.id,
        where: s.id in ^user_scope or s.private == false)
      |> Repo.all()
    end
  end

  def selected_filtered_scopes(organization, scope) do
    (from s in Scope,
      where: s.organization_id == ^organization.id,
      where: s.id == ^(String.to_integer(scope))
    )
    |> Repo.one()
  end

  def list_user_scopes(current_user) do
    Ecto.assoc(Repo.get(User, current_user.id), :scopes) |> Repo.all
  end

  def delete_scope_from_decision(decision_id) do
    Ecto.assoc(Repo.get(Decision, decision_id), :scope_decisions) |> Repo.delete_all
  end

  def assign_scopes_to_decision(scope, decision_id) do
    case Repo.get(Scope, scope) do
      scope -> create_scope_decision(%{"scope_id" => scope.id, "decision_id" => decision_id})
    end
  end

  def assign_scopes_from_draft_to_decision(scopes, decision_id) do
    for scope <- scopes do
      case Repo.get(Scope, scope.id) do
        scope -> create_scope_decision(%{"scope_id" => scope.id, "decision_id" => decision_id})
      end
    end
  end

  @doc """
  Gets a single scope.

  Raises `Ecto.NoResultsError` if the Scope does not exist.

  ## Examples

      iex> get_scope!(123)
      %Scope{}

      iex> get_scope!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scope!(id), do: Repo.get!(Scope, id)


  def get_decisions_for_scope(id) do
    (Repo.all Ecto.assoc(Repo.get(Scope, id), :decisions))
    |> Repo.preload([:user, :tags, :users, :scopes])
    |> Enum.group_by(& &1.date)
    |> Enum.map(fn {date, decisions_collection} -> %{date: date, decisions: decisions_collection} end)
    |> Enum.sort_by(&(&1.date), {:desc, Date})
  end


  @doc """
  Creates a scope.

  ## Examples

      iex> create_scope(%{field: value})
      {:ok, %Scope{}}

      iex> create_scope(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scope(attrs \\ %{}) do
    cleaned_scope = (attrs["name"] |> String.downcase(:ascii) |> String.trim(" "))
    case Repo.exists?((from s in Scope, where: s.organization_id == ^attrs["organization_id"] and s.name == ^cleaned_scope )) do
      false -> %Scope{} |> Scope.changeset(Map.merge(attrs, %{"name" => cleaned_scope})) |> Repo.insert()
      true -> {:error, "Scope already exists."}
    end
  end

  @doc """
  Updates a scope.

  ## Examples

      iex> update_scope(scope, %{field: new_value})
      {:ok, %Scope{}}

      iex> update_scope(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scope(%Scope{} = scope, attrs) do
    scope
    |> Scope.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scope.

  ## Examples

      iex> delete_scope(scope)
      {:ok, %Scope{}}

      iex> delete_scope(scope)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scope(%Scope{} = scope) do
    Repo.delete(scope)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scope changes.

  ## Examples

      iex> change_scope(scope)
      %Ecto.Changeset{data: %Scope{}}

  """
  def change_scope(%Scope{} = scope, attrs \\ %{}) do
    Scope.changeset(scope, attrs)
  end

  alias Histora.Scopes.Scope_decision

  @doc """
  Returns the list of scope_decisions.

  ## Examples

      iex> list_scope_decisions()
      [%Scope_decision{}, ...]

  """
  def list_scope_decisions do
    Repo.all(Scope_decision)
  end

  @doc """
  Gets a single scope_decision.

  Raises `Ecto.NoResultsError` if the Scope decision does not exist.

  ## Examples

      iex> get_scope_decision!(123)
      %Scope_decision{}

      iex> get_scope_decision!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scope_decision!(id), do: Repo.get!(Scope_decision, id)

  @doc """
  Creates a scope_decision.

  ## Examples

      iex> create_scope_decision(%{field: value})
      {:ok, %Scope_decision{}}

      iex> create_scope_decision(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scope_decision(attrs \\ %{}) do
    %Scope_decision{}
    |> Scope_decision.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a scope_decision.

  ## Examples

      iex> update_scope_decision(scope_decision, %{field: new_value})
      {:ok, %Scope_decision{}}

      iex> update_scope_decision(scope_decision, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scope_decision(%Scope_decision{} = scope_decision, attrs) do
    scope_decision
    |> Scope_decision.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scope_decision.

  ## Examples

      iex> delete_scope_decision(scope_decision)
      {:ok, %Scope_decision{}}

      iex> delete_scope_decision(scope_decision)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scope_decision(%Scope_decision{} = scope_decision) do
    Repo.delete(scope_decision)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scope_decision changes.

  ## Examples

      iex> change_scope_decision(scope_decision)
      %Ecto.Changeset{data: %Scope_decision{}}

  """
  def change_scope_decision(%Scope_decision{} = scope_decision, attrs \\ %{}) do
    Scope_decision.changeset(scope_decision, attrs)
  end


  def create_scope_users(users, scope) do
    for user_item <- users |> Enum.map(&String.to_integer/1) do
      %Scope_user{}
        |> Scope_user.changeset(%{"user_id" => user_item, "scope_id" => scope})
        |> Repo.insert()
    end
  end

  def update_scope_users(users, scope_id) do
    (from su in Scope_user, where: su.scope_id == ^scope_id) |> Repo.delete_all
    for user_item <- users |> Enum.map(&String.to_integer/1) do
      %Scope_user{}
        |> Scope_user.changeset(%{"user_id" => user_item, "scope_id" => scope_id})
        |> Repo.insert()
    end
  end

  def get_scope_users(id) do
    (Repo.all Ecto.assoc(Repo.get(Scope, id), :users))
  end

  def get_user_scopes(id) do
    (Repo.all Ecto.assoc(Repo.get(User, id), :scopes))
  end

  @doc """
  Returns the list of scope_users.

  ## Examples

      iex> list_scope_users()
      [%Scope_user{}, ...]

  """
  def list_scope_users do
    Repo.all(Scope_user)
  end

  @doc """
  Gets a single scope_user.

  Raises `Ecto.NoResultsError` if the Scope user does not exist.

  ## Examples

      iex> get_scope_user!(123)
      %Scope_user{}

      iex> get_scope_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scope_user!(id), do: Repo.get!(Scope_user, id)

  @doc """
  Creates a scope_user.

  ## Examples

      iex> create_scope_user(%{field: value})
      {:ok, %Scope_user{}}

      iex> create_scope_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scope_user(attrs \\ %{}) do
    %Scope_user{}
    |> Scope_user.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a scope_user.

  ## Examples

      iex> update_scope_user(scope_user, %{field: new_value})
      {:ok, %Scope_user{}}

      iex> update_scope_user(scope_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scope_user(%Scope_user{} = scope_user, attrs) do
    scope_user
    |> Scope_user.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scope_user.

  ## Examples

      iex> delete_scope_user(scope_user)
      {:ok, %Scope_user{}}

      iex> delete_scope_user(scope_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scope_user(%Scope_user{} = scope_user) do
    Repo.delete(scope_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scope_user changes.

  ## Examples

      iex> change_scope_user(scope_user)
      %Ecto.Changeset{data: %Scope_user{}}

  """
  def change_scope_user(%Scope_user{} = scope_user, attrs \\ %{}) do
    Scope_user.changeset(scope_user, attrs)
  end
end
