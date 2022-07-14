defmodule Histora.Scopes do
  @moduledoc """
  The Scopes context.
  """

  import Ecto.Query, warn: false
  alias Histora.Repo

  alias Histora.Scopes.Scope

  @doc """
  Returns the list of scopes.

  ## Examples

      iex> list_scopes()
      [%Scope{}, ...]

  """
  def list_scopes do
    Repo.all(Scope)
  end

  def list_organization_scopes(organization) do
    (from s in Scope, where: s.organization_id == ^organization.id ) |> Repo.all()
  end

  def assign_scope_to_record(scope, record_id, organization_id, user_id) do
    for scope_item <- String.split(scope, ", ") do
      cleaned_scope = (
      scope_item
      |> String.downcase(:ascii)
      |> String.trim(" ")
      )
      case Repo.get_by(Scope, name: cleaned_scope) do
        nil ->
          case create_scope(%{"name" => cleaned_scope, "organization_id" => organization_id, "user_id" => user_id}) do
            {:ok, scope} ->
              create_scope_record(%{"scope_id" => scope.id, "record_id" => record_id})
            {:error, %Ecto.Changeset{} = changeset} -> changeset.error
          end
        scope -> create_scope_record(%{"scope_id" => scope.id, "record_id" => record_id})
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


  def get_records_for_scope(id) do
    (Repo.all Ecto.assoc(Repo.get(Scope, id), :records))
      |> Repo.preload([:user, :tags, :users, :scopes])
      |> Enum.group_by(& NaiveDateTime.to_date(&1.updated_at))
      |> Enum.map(fn {updated_at, records_collection} -> %{date: updated_at, records: records_collection} end)
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
    case Repo.get_by(Scope, name: cleaned_scope) do
      nil -> %Scope{} |> Scope.changeset(Map.merge(attrs, %{"name" => cleaned_scope})) |> Repo.insert()
      scope -> {:ok, scope}
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

  alias Histora.Scopes.Scope_record

  @doc """
  Returns the list of scope_records.

  ## Examples

      iex> list_scope_records()
      [%Scope_record{}, ...]

  """
  def list_scope_records do
    Repo.all(Scope_record)
  end

  @doc """
  Gets a single scope_record.

  Raises `Ecto.NoResultsError` if the Scope record does not exist.

  ## Examples

      iex> get_scope_record!(123)
      %Scope_record{}

      iex> get_scope_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scope_record!(id), do: Repo.get!(Scope_record, id)

  @doc """
  Creates a scope_record.

  ## Examples

      iex> create_scope_record(%{field: value})
      {:ok, %Scope_record{}}

      iex> create_scope_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scope_record(attrs \\ %{}) do
    %Scope_record{}
    |> Scope_record.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a scope_record.

  ## Examples

      iex> update_scope_record(scope_record, %{field: new_value})
      {:ok, %Scope_record{}}

      iex> update_scope_record(scope_record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scope_record(%Scope_record{} = scope_record, attrs) do
    scope_record
    |> Scope_record.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scope_record.

  ## Examples

      iex> delete_scope_record(scope_record)
      {:ok, %Scope_record{}}

      iex> delete_scope_record(scope_record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scope_record(%Scope_record{} = scope_record) do
    Repo.delete(scope_record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scope_record changes.

  ## Examples

      iex> change_scope_record(scope_record)
      %Ecto.Changeset{data: %Scope_record{}}

  """
  def change_scope_record(%Scope_record{} = scope_record, attrs \\ %{}) do
    Scope_record.changeset(scope_record, attrs)
  end

  alias Histora.Scopes.Scope_user


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
