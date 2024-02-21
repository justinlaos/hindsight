defmodule Hindsight.DecisionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hindsight.Decisions` context.
  """

  @doc """
  Generate a approval.
  """
  def approval_fixture(attrs \\ %{}) do
    {:ok, approval} =
      attrs
      |> Enum.into(%{

      })
      |> Hindsight.Decisions.create_approval()

      approval
  end
end
