defmodule Histora.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Accounts.create_account()

    account
  end
end
