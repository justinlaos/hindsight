defmodule Histora.ScopeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Scope` context.
  """

  @doc """
  Generate a scopes.
  """
  def scopes_fixture(attrs \\ %{}) do
    {:ok, scopes} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Scope.create_scopes()

    scopes
  end
end
