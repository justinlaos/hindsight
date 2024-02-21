defmodule Hindsight.ReflectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hindsight.Reflections` context.
  """

  @doc """
  Generate a reflection.
  """
  def reflection_fixture(attrs \\ %{}) do
    {:ok, reflection} =
      attrs
      |> Enum.into(%{

      })
      |> Hindsight.Reflections.create_reflection()

    reflection
  end
end
