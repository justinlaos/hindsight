defmodule Histora.DecisionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Decisions` context.
  """

  @doc """
  Generate a approval.
  """
  def approval_fixture(attrs \\ %{}) do
    {:ok, approval} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Decisions.create_approval()

      approval
  end
end
