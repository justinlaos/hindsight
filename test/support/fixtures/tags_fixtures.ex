defmodule Histora.TagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Tags` context.
  """

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Tags.create_tag()

    tag
  end

  @doc """
  Generate a tag_record.
  """
  def tag_record_fixture(attrs \\ %{}) do
    {:ok, tag_record} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Tags.create_tag_record()

    tag_record
  end

  @doc """
  Generate a tag_favorite.
  """
  def tag_favorite_fixture(attrs \\ %{}) do
    {:ok, tag_favorite} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Tags.create_tag_favorite()

    tag_favorite
  end
end
