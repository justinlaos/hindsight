defmodule Histora.RecordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Records` context.
  """

  @doc """
  Generate a record.
  """
  def record_fixture(attrs \\ %{}) do
    {:ok, record} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Records.create_record()

    record
  end

  @doc """
  Generate a record_user.
  """
  def record_user_fixture(attrs \\ %{}) do
    {:ok, record_user} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Records.create_record_user()

    record_user
  end
end
