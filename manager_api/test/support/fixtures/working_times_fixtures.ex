defmodule ManagerApi.WorkingTimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ManagerApi.WorkingTimes` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: "some end",
        start: "some start"
      })
      |> ManagerApi.WorkingTimes.create_working_time()

    working_time
  end
end
