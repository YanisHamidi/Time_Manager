defmodule ManagerApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ManagerApi.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> ManagerApi.Users.create_user()

    user
  end
end
