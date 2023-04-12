defmodule Histora.Tags do
  @moduledoc """
  The Tags context.
  """

  import Ecto.Query, warn: false

  alias Histora.Repo
  alias Histora.Tags.Tag
  alias Histora.Tags.Tag_decision
  alias Histora.Decisions.Decision

  def list_organization_tags(organization) do
    (from t in Tag,
      where: t.organization_id == ^organization.id,
      preload: [:decisions],
      order_by: [desc: (t.id)],
      group_by: t.id,
      select: t
    )
    |> Repo.all()
  end

  def list_organization_tags_for_decisions(organization_id) do
    (from t in Tag,
      where: t.organization_id == ^organization_id,
      order_by: [desc: (t.id)],
      group_by: t.id,
      select: t
    )
    |> Repo.all()
  end


  def selected_filtered_tags(organization, tag_list) do
    (from t in Tag,
      where: t.organization_id == ^organization.id,
      where: t.id == ^String.to_integer(tag_list)
    )
    |> Repo.all()
  end

  def list_organization_tags_with_2_decisions(organization) do
    (from t in Tag, where: t.organization_id == ^organization.id)
      |> Repo.all()
      |> Repo.preload(decisions: from(r in Decision, order_by: [desc: r.inserted_at], preload: [:tags, :user]))

  end

  def delete_decision_tag_list(decision_id) do
    Ecto.assoc(Repo.get(Decision, decision_id), :tag_decisions) |> Repo.delete_all
  end

  def assign_tags_to_decision(tags, decision_id, organization_id, user_id) do
    for tag_item <- String.split(tags, ", ", trim: true) do
      cleaned_tag = (
      tag_item
      |> String.downcase(:ascii)
      |> String.trim(" ")
      )
      case Repo.get_by(Tag, name: cleaned_tag) do
        nil ->
          case create_tag(%{"name" => cleaned_tag, "organization_id" => organization_id, "user_id" => user_id}) do
            {:ok, tag} ->
              create_tag_decision(%{"tag_id" => tag.id, "decision_id" => decision_id})
            {:error, %Ecto.Changeset{} = changeset} -> changeset.error
          end
        tag -> create_tag_decision(%{"tag_id" => tag.id, "decision_id" => decision_id})
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
    Repo.get!(Tag, id)
  end

  def get_decisions_for_tag(id) do
    (Repo.all Ecto.assoc(Repo.get(Tag, id), :decisions))
      |> Repo.preload([:user, :tags])
      |> Enum.group_by(& formate_time_stamp(&1.inserted_at))
      |> Enum.map(fn {inserted_at, decisions_collection} -> %{date: inserted_at, decisions: decisions_collection} end)
      |> Enum.reverse()
  end

  defp formate_time_stamp(date) do
    case Timex.format({date.year, date.month, date.day}, "{Mfull} {D}, {YYYY}") do
      {:ok, date} -> date
      {:error, message} -> message
    end
  end

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  def get_tag_decision!(id), do: Repo.get!(Tag_decision, id)

  def create_tag_decision(attrs \\ %{}) do
    %Tag_decision{}
    |> Tag_decision.changeset(attrs)
    |> Repo.insert()
  end

  def update_tag_decision(%Tag_decision{} = tag_decision, attrs) do
    tag_decision
    |> Tag_decision.changeset(attrs)
    |> Repo.update()
  end

  def delete_tag_decision(%Tag_decision{} = tag_decision) do
    Repo.delete(tag_decision)
  end

  def change_tag_decision(%Tag_decision{} = tag_decision, attrs \\ %{}) do
    Tag_decision.changeset(tag_decision, attrs)
  end
end
