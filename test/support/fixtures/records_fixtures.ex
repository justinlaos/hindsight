defmodule Histora.DecisionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Decisions` context.
  """

  @doc """
  Generate a decision.
  """
  def decision_fixture(attrs \\ %{}) do
    {:ok, decision} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Decisions.create_decision()

    decision
  end

  @doc """
  Generate a decision_user.
  """
  def decision_user_fixture(attrs \\ %{}) do
    {:ok, decision_user} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Decisions.create_decision_user()

    decision_user
  end
end
