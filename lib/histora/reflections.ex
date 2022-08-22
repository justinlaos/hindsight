defmodule Histora.Reflections do
  @moduledoc """
  The Reflections context.
  """

  import Ecto.Query, warn: false
  alias Histora.Repo

  alias Histora.Reflections.Reflection
  alias Histora.Decisions.Decision

  @doc """
  Returns the list of reflections.

  ## Examples

      iex> list_reflections()
      [%Reflection{}, ...]

  """
  def list_reflections do
    Repo.all(Reflection)
  end

  def list_upcoming_reflection_decisions(organization, formated_start_date, formated_end_date) do
    (from d in Decision,
    left_join: r in assoc(d, :reflections),
      where: is_nil(r.decision_id) and
        d.organization_id == ^organization.id and
        is_nil(d.reflection_date) == false and
        is_nil(r) == true and
        d.reflection_date >= ^formated_start_date and
        d.reflection_date <= ^formated_end_date,
        preload: [:user, :tags, :users, :scopes] )
    |> Repo.all()
    |> Enum.group_by(& &1.reflection_date)
    |> Enum.map(fn {reflection_date, decisions_collection} -> %{reflection_date: reflection_date, decisions: decisions_collection} end)
    |> Enum.sort_by(&(&1.reflection_date), {:asc, Date})
  end

  def list_past_due_reflection_decisions(organization) do
    (from d in Decision,
      left_join: r in assoc(d, :reflections),
      where: is_nil(r.decision_id) and
        d.organization_id == ^organization.id and
        is_nil(d.reflection_date) == false and
        d.reflection_date < ^todays_date(),
      preload: [:user, :tags, :users, :scopes] )
    |> Repo.all()
    |> Enum.group_by(& &1.reflection_date)
    |> Enum.map(fn {reflection_date, decisions_collection} -> %{reflection_date: reflection_date, decisions: decisions_collection} end)
    |> Enum.sort_by(&(&1.reflection_date), {:asc, Date})
  end

  def list_all_reflection_decisions(organization) do
    (from d in Decision,
    left_join: r in assoc(d, :reflections),
    where: is_nil(r.decision_id) and
      d.organization_id == ^organization.id and
      is_nil(d.reflection_date) == false and
      is_nil(r) == true,
      preload: [:user, :tags, :users, :scopes] )
    |> Repo.all()
    |> Enum.group_by(& &1.reflection_date)
    |> Enum.map(fn {reflection_date, decisions_collection} -> %{reflection_date: reflection_date, decisions: decisions_collection} end)
    |> Enum.sort_by(&(&1.reflection_date), {:asc, Date})
  end

  def todays_date do
    date_string = Date.to_string(Date.utc_today)
      {:ok, date} = NaiveDateTime.new Date.from_iso8601!(date_string), ~T[00:00:00]
      date
  end

  @doc """
  Gets a single reflection.

  Raises `Ecto.NoResultsError` if the Reflection does not exist.

  ## Examples

      iex> get_reflection!(123)
      %Reflection{}

      iex> get_reflection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reflection!(id), do: Repo.get!(Reflection, id)

  @doc """
  Creates a reflection.

  ## Examples

      iex> create_reflection(%{field: value})
      {:ok, %Reflection{}}

      iex> create_reflection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reflection(attrs \\ %{}) do
    %Reflection{}
    |> Reflection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reflection.

  ## Examples

      iex> update_reflection(reflection, %{field: new_value})
      {:ok, %Reflection{}}

      iex> update_reflection(reflection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reflection(%Reflection{} = reflection, attrs) do
    reflection
    |> Reflection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reflection.

  ## Examples

      iex> delete_reflection(reflection)
      {:ok, %Reflection{}}

      iex> delete_reflection(reflection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reflection(%Reflection{} = reflection) do
    Repo.delete(reflection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reflection changes.

  ## Examples

      iex> change_reflection(reflection)
      %Ecto.Changeset{data: %Reflection{}}

  """
  def change_reflection(%Reflection{} = reflection, attrs \\ %{}) do
    Reflection.changeset(reflection, attrs)
  end
end