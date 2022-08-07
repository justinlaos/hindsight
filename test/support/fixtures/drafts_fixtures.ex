defmodule Histora.DraftsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Drafts` context.
  """

  @doc """
  Generate a draft.
  """
  def draft_fixture(attrs \\ %{}) do
    {:ok, draft} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Drafts.create_draft()

    draft
  end

  @doc """
  Generate a draft_user.
  """
  def draft_user_fixture(attrs \\ %{}) do
    {:ok, draft_user} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Drafts.create_draft_user()

    draft_user
  end

  @doc """
  Generate a draft_scope.
  """
  def draft_scope_fixture(attrs \\ %{}) do
    {:ok, draft_scope} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Drafts.create_draft_scope()

    draft_scope
  end

  @doc """
  Generate a draft_option.
  """
  def draft_option_fixture(attrs \\ %{}) do
    {:ok, draft_option} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Drafts.create_draft_option()

    draft_option
  end

  @doc """
  Generate a draft_vote.
  """
  def draft_vote_fixture(attrs \\ %{}) do
    {:ok, draft_vote} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Drafts.create_draft_vote()

    draft_vote
  end
end
