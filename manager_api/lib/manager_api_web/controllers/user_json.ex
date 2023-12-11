defmodule ManagerApiWeb.UserJSON do
  alias ManagerApi.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

    @doc """
  Renders a sign-in response.
  """
  def sign_in(%{user: user, token: token}) do
    %{data: sign_in_data(user, token)}
  end

    @doc """
  Renders a JSON response for the sign_in action with an error.
  """
  def sign_in_error(%{reason: reason}) do
    %{error: reason}
  end



  @doc false
  defp sign_in_data(%User{} = user, token) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      token: token,
      role: user.role,
      society: user.society,
      manager_id: user.manager_id
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      society: user.society,
      manager_id: user.manager_id
    }
  end

  def decode_token(%{claims: claims}) do
    %{data: claims}
  end
end
