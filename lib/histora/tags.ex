defmodule Histora.Tags do
  @moduledoc """
  The Tags context.
  """

  import Ecto.Query, warn: false

  alias Histora.Repo
  alias Histora.Tags.Tag
  alias Histora.Tags.Tag_record
  alias Histora.Tags.Tag_favorite
  alias Histora.Records.Record

  def list_organization_tags(organization) do
    (from t in Tag,
      where: t.organization_id == ^organization.id,
      preload: [:tag_favorites],
      left_join: fav in assoc(t, :tag_favorites),
      order_by: [desc: count(fav.id), desc: (t.id)],
      group_by: t.id,
      select: t
    )
    |> Repo.all()
  end

  def list_organization_tags_for_records(organization_id) do
    (from t in Tag,
      where: t.organization_id == ^organization_id,
      preload: [:tag_favorites],
      left_join: fav in assoc(t, :tag_favorites),
      order_by: [desc: count(fav.id), desc: (t.id)],
      group_by: t.id,
      select: t
    )
    |> Repo.all()
  end

  def list_organization_tags_with_2_records(organization) do
    (from t in Tag, where: t.organization_id == ^organization.id)
      |> Repo.all()
      |> Repo.preload(records: from(r in Record, order_by: [desc: r.inserted_at], preload: [:tags, :user]))

  end

  def assign_tags_to_record(tags, record_id, organization_id, user_id) do
    for tag_item <- String.split(tags, ", ") do
      cleaned_tag = (
      tag_item
      |> String.downcase(:ascii)
      |> String.trim(" ")
      )
      case Repo.get_by(Tag, name: cleaned_tag) do
        nil ->
          case create_tag(%{"name" => cleaned_tag, "organization_id" => organization_id, "user_id" => user_id}) do
            {:ok, tag} ->
              create_tag_record(%{"tag_id" => tag.id, "record_id" => record_id})
            {:error, %Ecto.Changeset{} = changeset} -> changeset.error
          end
        tag -> create_tag_record(%{"tag_id" => tag.id, "record_id" => record_id})
      end
    end
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """


  def get_tag!(id) do
    Repo.get!(Tag, id) |> Repo.preload(:tag_favorites)
  end

  def get_records_for_tag(id) do
    (Repo.all Ecto.assoc(Repo.get(Tag, id), :records))
      |> Repo.preload([:user, :tags])
      |> Enum.group_by(& formate_time_stamp(&1.inserted_at))
      |> Enum.map(fn {inserted_at, records_collection} -> %{date: inserted_at, records: records_collection} end)
      |> Enum.reverse()
  end

  defp formate_time_stamp(date) do
    case Timex.format({date.year, date.month, date.day}, "{Mfull} {D}, {YYYY}") do
      {:ok, date} -> date
      {:error, message} -> message
    end
  end

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  @doc """
  Gets a single tag_record.

  Raises `Ecto.NoResultsError` if the Tag record does not exist.

  ## Examples

      iex> get_tag_record!(123)
      %Tag_record{}

      iex> get_tag_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag_record!(id), do: Repo.get!(Tag_record, id)

  @doc """
  Creates a tag_record.

  ## Examples

      iex> create_tag_record(%{field: value})
      {:ok, %Tag_record{}}

      iex> create_tag_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag_record(attrs \\ %{}) do
    %Tag_record{}
    |> Tag_record.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag_record.

  ## Examples

      iex> update_tag_record(tag_record, %{field: new_value})
      {:ok, %Tag_record{}}

      iex> update_tag_record(tag_record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag_record(%Tag_record{} = tag_record, attrs) do
    tag_record
    |> Tag_record.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag_record.

  ## Examples

      iex> delete_tag_record(tag_record)
      {:ok, %Tag_record{}}

      iex> delete_tag_record(tag_record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag_record(%Tag_record{} = tag_record) do
    Repo.delete(tag_record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag_record changes.

  ## Examples

      iex> change_tag_record(tag_record)
      %Ecto.Changeset{data: %Tag_record{}}

  """
  def change_tag_record(%Tag_record{} = tag_record, attrs \\ %{}) do
    Tag_record.changeset(tag_record, attrs)
  end

  def create_tag_favorite(attrs \\ %{}) do
    %Tag_favorite{}
    |> Tag_favorite.changeset(attrs)
    |> Repo.insert()
  end

  def get_tag_favorite!(tag_id, user_id) do
    (from t in Tag_favorite, where: t.tag_id == ^tag_id and t.user_id == ^user_id) |> Repo.one()
  end

  def delete_tag_favorite(%Tag_favorite{} = tag_favorite) do
    Repo.delete(tag_favorite)
  end
end
