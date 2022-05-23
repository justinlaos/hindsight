defmodule Histora.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Users` context.
  """

  @doc """
  Generate a user_favorite.
  """
  def user_favorite_fixture(attrs \\ %{}) do
    {:ok, user_favorite} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Users.create_user_favorite()

    user_favorite
  end
end
