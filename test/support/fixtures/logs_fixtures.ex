defmodule Histora.LogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Histora.Logs` context.
  """

  @doc """
  Generate a log.
  """
  def log_fixture(attrs \\ %{}) do
    {:ok, log} =
      attrs
      |> Enum.into(%{

      })
      |> Histora.Logs.create_log()

    log
  end
end
