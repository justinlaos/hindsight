defmodule Histora.TeamFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Team` context.
  """

  @doc """
  Generate a teams.
  """
  def teams_fixture(attrs \\ %{}) do
    {:ok, teams} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Team.create_teams()

    teams
  end
end
