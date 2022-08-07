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
  Generate a tag_decision.
  """
  def tag_decision_fixture(attrs \\ %{}) do
    {:ok, tag_decision} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Tags.create_tag_decision()

    tag_decision
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
