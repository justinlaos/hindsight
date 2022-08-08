defmodule Histora.ScopesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Scopes` context.
  """

  @doc """
  Generate a scope.
  """
  def scope_fixture(attrs \\ %{}) do
    {:ok, scope} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Scopes.create_scope()

    scope
  end

  @doc """
  Generate a scope_decision.
  """
  def scope_decision_fixture(attrs \\ %{}) do
    {:ok, scope_decision} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Scopes.create_scope_decision()

    scope_decision
  end

  @doc """
  Generate a scope_user.
  """
  def scope_user_fixture(attrs \\ %{}) do
    {:ok, scope_user} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Scopes.create_scope_user()

    scope_user
  end
end