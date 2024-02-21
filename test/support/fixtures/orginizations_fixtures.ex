defmodule Hindsight.OrginizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hindsight.Orginizations` context.
  """

  @doc """
  Generate a orginization.
  """
  def orginization_fixture(attrs \\ %{}) do
    {:ok, orginization} =
      attrs
      |> Enum.into(%{

      })
      |> Hindsight.Orginizations.create_orginization()

    orginization
  end
end
