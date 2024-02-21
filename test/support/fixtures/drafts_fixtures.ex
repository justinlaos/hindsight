defmodule Hindsight.DraftsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hindsight.Drafts` context.
  """

  @doc """
  Generate a draft.
  """
  def draft_fixture(attrs \\ %{}) do
    {:ok, draft} =
      attrs
      |> Enum.into(%{

      })
      |> Hindsight.Drafts.create_draft()

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
      |> Hindsight.Drafts.create_draft_user()

    draft_user
  end

  @doc """
  Generate a draft_team.
  """
  def draft_team_fixture(attrs \\ %{}) do
    {:ok, draft_team} =
      attrs
      |> Enum.into(%{

      })
      |> Hindsight.Drafts.create_draft_team()

    draft_team
  end

  @doc """
  Generate a draft_option.
  """
  def draft_option_fixture(attrs \\ %{}) do
    {:ok, draft_option} =
      attrs
      |> Enum.into(%{

      })
      |> Hindsight.Drafts.create_draft_option()

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
      |> Hindsight.Drafts.create_draft_vote()

    draft_vote
  end
end
