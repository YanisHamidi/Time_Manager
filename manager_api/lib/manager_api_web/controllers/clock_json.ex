defmodule ManagerApiWeb.ClockJSON do
  alias ManagerApi.Clocks.Clock

  @doc """
  Renders a list of clocks.
  """
def index(%{clocks: [last_clock | _]}) do
  %{data: data(last_clock)}
end

def index(_params) do
  %{data: []}
end

  @doc """
  Renders a single clock.
  """
  def show(%{clock: clock}) do
    %{data: data(clock)}
  end

  defp data(%Clock{} = clock) do
    %{
      id: clock.id,
      time: clock.time,
      status: clock.status
    }
  end
end
