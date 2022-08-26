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

  @doc """
  Generate a user_data.
  """
  def user_data_fixture(attrs \\ %{}) do
    {:ok, user_data} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Users.create_user_data()

    user_data
  end
end
