defmodule Hindsight.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hindsight.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{

      })
      |> Hindsight.Teams.create_team()

    team
  end

  @doc """
  Generate a team_decision.
  """
  def team_decision_fixture(attrs \\ %{}) do
    {:ok, team_decision} =
      attrs
      |> Enum.into(%{

      })
      |> Hindsight.Teams.create_team_decision()

    team_decision
  end

  @doc """
  Generate a team_user.
  """
  def team_user_fixture(attrs \\ %{}) do
    {:ok, team_user} =
      attrs
      |> Enum.into(%{

      })
      |> Hindsight.Teams.create_team_user()

    team_user
  end
end
