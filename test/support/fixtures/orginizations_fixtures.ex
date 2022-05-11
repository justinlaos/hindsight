defmodule Histora.OrginizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Orginizations` context.
  """

  @doc """
  Generate a orginization.
  """
  def orginization_fixture(attrs \\ %{}) do
    {:ok, orginization} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Orginizations.create_orginization()

    orginization
  end
end
