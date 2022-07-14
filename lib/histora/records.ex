defmodule Histora.Records do
  @moduledoc """
  The Records context.
  """

  import Ecto.Query, warn: false
  alias Histora.Repo

  alias Histora.Tags.Tag_record
  alias Histora.Scopes
  alias Histora.Scopes.Scope_user
  alias Histora.Records.Record
  alias Histora.Tags.Tag

  def list_organization_records(organization) do
    (from r in Record, where: r.organization_id == ^organization.id)
  end

  def filter_tags(records, params) do
    if Map.has_key?(params, "tag_list") do
      filtered_tags = params["tag_list"] |> Enum.map(&String.to_integer/1)
      (from r in subquery(records),
      join: t in Tag_record, on: r.id == t.record_id,
      join: tt in Tag, on: tt.id == t.tag_id,
      where: tt.id in ^filtered_tags )
    else
      records
    end
  end

  def filter_users(records, params) do
    if Map.has_key?(params, "users") do
      filtered_users = params["users"] |> Enum.map(&String.to_integer/1)
      (from r in subquery(records),
      where: r.user_id in ^filtered_users )
    else
      records
    end
  end

  def filter_dates(records, formated_start_date, formated_end_date) do
      (from r in subquery(records), where: r.updated_at >= ^formated_start_date and r.updated_at <= ^formated_end_date )
  end

  def formate_records(records) do
    (from r in subquery(records), preload: [:user, :tags, :users, :scopes])
    |> Repo.all()
    |> Enum.group_by(& NaiveDateTime.to_date(&1.updated_at))
    |> Enum.map(fn {updated_at, records_collection} -> %{date: updated_at, records: records_collection} end)
    |> Enum.sort_by(&(&1.date), {:desc, Date})

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

  def formate_records_count(records) do
    records |> Repo.all()
  end


  @doc """
  Gets a single record.

  Raises `Ecto.NoResultsError` if the Record does not exist.

  ## Examples

      iex> get_record!(123)
      %Record{}

      iex> get_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_record!(id) do
    Repo.get!(Record, id) |> Repo.preload([:user, :tags, :users, :scopes])
  end

  @doc """
  Creates a record.

  ## Examples

      iex> create_record(%{field: value})
      {:ok, %Record{}}

      iex> create_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_record(attrs \\ %{}) do
    %Record{}
    |> Record.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a record.

  ## Examples

      iex> update_record(record, %{field: new_value})
      {:ok, %Record{}}

      iex> update_record(record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_record(%Record{} = record, attrs) do
    record
    |> Record.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a record.

  ## Examples

      iex> delete_record(record)
      {:ok, %Record{}}

      iex> delete_record(record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_record(%Record{} = record) do
    Repo.delete(record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking record changes.

  ## Examples

      iex> change_record(record)
      %Ecto.Changeset{data: %Record{}}

  """
  def change_record(%Record{} = record, attrs \\ %{}) do
    Record.changeset(record, attrs)
  end

  alias Histora.Records.Record_user

  @doc """
  Returns the list of record_users.

  ## Examples

      iex> list_record_users()
      [%Record_user{}, ...]

  """
  def list_record_users do
    Repo.all(Record_user)
  end

  @doc """
  Gets a single record_user.

  Raises `Ecto.NoResultsError` if the Record user does not exist.

  ## Examples

      iex> get_record_user!(123)
      %Record_user{}

      iex> get_record_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_record_user!(id), do: Repo.get!(Record_user, id)

  @doc """
  Creates a record_user.

  ## Examples

      iex> create_record_user(%{field: value})
      {:ok, %Record_user{}}

      iex> create_record_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_record_user(attrs \\ %{}) do
    %Record_user{}
    |> Record_user.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a record_user.

  ## Examples

      iex> update_record_user(record_user, %{field: new_value})
      {:ok, %Record_user{}}

      iex> update_record_user(record_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_record_user(%Record_user{} = record_user, attrs) do
    record_user
    |> Record_user.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a record_user.

  ## Examples

      iex> delete_record_user(record_user)
      {:ok, %Record_user{}}

      iex> delete_record_user(record_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_record_user(%Record_user{} = record_user) do
    Repo.delete(record_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking record_user changes.

  ## Examples

      iex> change_record_user(record_user)
      %Ecto.Changeset{data: %Record_user{}}

  """
  def change_record_user(%Record_user{} = record_user, attrs \\ %{}) do
    Record_user.changeset(record_user, attrs)
  end

  def connect_scope_users_to_record(record_id, scope_id) do
    for user <- Scopes.get_scope_users(scope_id) do
      %Record_user{}
        |> Record_user.changeset(%{"user_id" => user.id, "record_id" => record_id, "from_scope" => true})
        |> Repo.insert()
    end
  end

  def get_record_users_with_scope(record_id) do
    (from ru in Record_user, where: ru.record_id == ^record_id and ru.from_scope == true, preload: [:user]) |> Repo.all
  end

  def get_record_users_without_scope(record_id) do
    (from ru in Record_user, where: ru.record_id == ^record_id and ru.from_scope == false) |> Repo.all
  end
end
