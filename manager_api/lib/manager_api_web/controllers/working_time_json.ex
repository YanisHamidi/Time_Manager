defmodule ManagerApiWeb.WorkingTimeJSON do
  alias ManagerApi.WorkingTimes.WorkingTime

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    %{data: for(working_time <- workingtimes, do: data(working_time))}
  end

  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  defp data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      working_time_seconds: working_time.working_time_seconds,
      username: ManagerApi.Users.get_username_by_id(working_time.user_id)
    }
  end
end
