defmodule Histora.GoalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Goals` context.
  """

  @doc """
  Generate a goal.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, goal} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Goals.create_goal()

    goal
  end

  @doc """
  Generate a tag_decision.
  """
  def tag_decision_fixture(attrs \\ %{}) do
    {:ok, tag_decision} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Goals.create_goal_decision()

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
      |> Histora.Goals.create_goal_favorite()

    tag_favorite
  end
end
