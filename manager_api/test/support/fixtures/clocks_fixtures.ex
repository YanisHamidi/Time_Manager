defmodule ManagerApi.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ManagerApi.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: "some status",
        time: "some time"
      })
      |> ManagerApi.Clocks.create_clock()

    clock
  end
end
