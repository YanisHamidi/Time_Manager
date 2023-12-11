defmodule ManagerApi.WorkingTimes do
  @moduledoc """
  The WorkingTimes context.
  """

  import Ecto.Query, warn: false
  alias ManagerApi.Repo

  alias ManagerApi.WorkingTimes.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  def list_workingtimes(user_id) do
    query =
      from w in WorkingTime,
      where: w.user_id == ^user_id

    Repo.all(query)
  end

  def list_workingtimes(user_id, start_date, end_date) do
    start_date = Date.from_iso8601!(start_date)
    end_date = Date.from_iso8601!(end_date)
    query =
      from w in WorkingTime,
      where: w.user_id == ^user_id and fragment("?::date >= ?::date", w.start, ^start_date) and fragment("?::date <= ?::date", w.start, ^end_date)
    Repo.all(query)
  end

  def list_working_times_by_society(society) do
    query =
      from wt in WorkingTime,
      join: u in ManagerApi.Users.User,
      on: u.id == wt.user_id,
      where: u.society == ^society,
      select: wt

    Repo.all(query)
  end

  def list_working_times_by_society(society, start_date, end_date) do
    start_date = Date.from_iso8601!(start_date)
    end_date = Date.from_iso8601!(end_date)
    query =
      from w in WorkingTime,
      join: u in ManagerApi.Users.User,
      on: u.id == w.user_id,
      where: u.society == ^society and fragment("?::date >= ?::date", w.start, ^start_date) and fragment("?::date <= ?::date", w.start, ^end_date),
      select: w

    Repo.all(query)
  end


  def list_working_times_by_manager_id(id) do
    query =
      from wt in WorkingTime,
      join: u in ManagerApi.Users.User,
      on: u.id == wt.user_id,
      where: u.manager_id == ^id,
      select: wt

    Repo.all(query)
  end

  def list_working_times_by_manager_id(id, start_date, end_date) do
    start_date = Date.from_iso8601(start_date)
    end_date = Date.from_iso8601(end_date)
    query =
      from w in WorkingTime,
      join: u in ManagerApi.Users.User,
      on: u.id == w.user_id,
      where: u.manager_id == ^id and fragment("?::date >= ?::date", w.start, ^start_date) and fragment("?::date <= ?::date", w.start, ^end_date),
      select: w

    Repo.all(query)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  def get_working_time_by_user_id(id, user_id) do
    query =
      from w in WorkingTime,
      where: w.id == ^id and w.user_id == ^user_id,
      select: w

    Repo.one(query)
    |> case do
      nil -> {:error, :not_found}
      working_time -> {:ok, working_time}
    end
  end


  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end
end
