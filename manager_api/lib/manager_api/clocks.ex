defmodule ManagerApi.Clocks do
  @moduledoc """
  The Clocks context.
  """

  import Ecto.Query, warn: false
  alias ManagerApi.Repo

  alias ManagerApi.Clocks.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  def list_clocks(user_id) do
    query =
      from w in Clock,
      where: w.user_id == ^user_id

    Repo.all(query)
  end

  def get_last_clock(user_id) do
    query =
      from w in Clock,
      where: w.user_id == ^user_id,
      order_by: [desc: w.id],
      limit: 1
    Repo.one(query)

  end


  def get_previous_clock_by_user_id(user_id) do
    query =
      from w in Clock,
      where: w.user_id == ^user_id,
      order_by: [desc: w.id],
      limit: 1,
      select: w

    case Repo.one(query) do
    %Clock{status: true} = clock -> {:ok, clock}
    _ -> {:ok, nil}
  end
  end



  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id) do
    query = from c in Clock, where: c.user_id == ^id
    Repo.all(query) |>Repo.preload([:user])
  end

  def get_clock_by_user_id(id, user_id) do
    query =
      from w in Clock,
      where: w.id == ^id and w.user_id == ^user_id,
      select: w

    Repo.one(query)
    |> case do
      nil -> {:error, :not_found}
      clock -> {:ok, clock}
    end
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

def create_clock(attrs \\ %{}) do
  current_time = DateTime.utc_now()
  %Clock{}
  |> Clock.changeset(Map.put(attrs, "time", current_time))
  |> Repo.insert()
end


  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end
end
