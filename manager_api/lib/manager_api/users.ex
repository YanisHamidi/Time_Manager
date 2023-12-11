defmodule ManagerApi.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Hex.API.User
  alias ManagerApi.Repo

  alias ManagerApi.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """

  def list_users(email, username) when is_binary(email) and is_binary(username) do
    query =
      from u in User,
      where: u.email == ^email and u.username == ^username

    Repo.all(query)
  end


  def list_users() do
    query =
      from u in User

    Repo.all(query)
  end

  def list_users_by_society(society) do
    query =
      from u in User,
      where: u.society == ^society

    Repo.all(query)
  end

  def list_users_by_manager_id(manager_id) do
    query =
      from u in User,
      where: u.manager_id == ^manager_id

    Repo.all(query)
  end


  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email(email) do
    User
    |> where(email: ^email)
    |> Repo.one()
  end

  def get_role_by_id(id) do
    case Repo.get(User, id) do
      %User{role: role} -> {:ok, role}
      nil -> {:error, :user_not_found}
    end
  end

  def get_username_by_id(id) do
    case Repo.get(User, id) do
      %User{username: username} -> username
      nil -> {:error, :user_not_found}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
