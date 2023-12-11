defmodule ManagerApiWeb.UserController do
  use ManagerApiWeb, :controller

  alias ManagerApi.Users
  alias ManagerApi.Users.User
  alias ManagerApiWeb.Auth.Guardian
  alias ManagerApiWeb.Plugs.UsersAuthorization

  plug UsersAuthorization when action in [:index, :create, :update, :delete , :show]

  action_fallback ManagerApiWeb.FallbackController


def index(conn, %{"email" => email, "username" => username} = params) when is_map(params) do
  users = Users.list_users(email, username)
  render(conn, :index, users: users)
end

def index(conn, _params) do
  current_user = conn.assigns[:current_user]
  users =
    case current_user.role do
      "GeneralManager" ->
        Users.list_users_by_society(current_user.society)
      "Manager" ->
        [current_user |Users.list_users_by_manager_id(current_user.id)]
      _ ->
        [current_user ]
    end

  render(conn, :index, users: users)
end

def create(conn, %{"user" => user_params}) do
  current_user = conn.assigns[:current_user]
  updated_user_params = Map.put(user_params, "manager_id", current_user.id)

  with {:ok, %User{} = user} <- Users.create_user(Map.put(updated_user_params, "society", current_user.society)) do
    conn
    |> put_status(:created)
    |> render(:show, user: user)
  else
    {:error, %Ecto.Changeset{} } ->
      conn
      |> put_status(:unprocessable_entity)
      |> render(ManagerApiWeb.ErrorJSON, "422.json")
  end
end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        conn
        |> put_status(:ok)
        |> render("sign_in.json", user: user, token: token)

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("sign_in_error.json", reason: reason)
    end
  end

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      case Guardian.authenticate(user.email, user_params["password"]) do
        {:ok, user, token} ->
          conn
          |> put_status(:created)
          |> render("sign_in.json", user: user, token: token)

        {:error, reason} ->
          conn
          |> put_status(:unauthorized)
          |> render("sign_in_error.json", reason: reason)
      end
    end
  end


  defp get_user_info(user_id) do
    Users.get_user!(user_id)
  end

  def verify_session(conn, %{"token" => token}) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        user_id = claims["sub"]
        user = get_user_info(user_id)
        conn
        |> put_status(:ok)
        |> render(:show, user: user)
      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> render(:show, reason: reason)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    case Users.get_user(id) do
      %User{} = user when user.manager_id == current_user.id or user.id == current_user.id ->
        render(conn, :show, user: user)

      nil ->
        conn
        |> put_status(:not_found)
        |> render(ManagerApiWeb.ErrorJSON, "404.json")

      _ ->
        conn
        |> put_status(:unauthorized)
        |> render(ManagerApiWeb.ErrorJSON, "401.json")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = conn.assigns[:current_user]

    case Users.get_user(id) do
      %User{} = user ->
        user_params =
          case current_user.role do
            "GeneralManager" when user.society == current_user.society ->
              update_user_params_manager(current_user, user, user_params)
            _ when user.society == current_user.society ->
              update_user_params_non_manager(conn, current_user, user, user_params)
            _ ->
              conn
              |> put_status(:unauthorized)
              |> render(ManagerApiWeb.ErrorJSON, "401.json")
          end

        with {:ok, %User{} = updated_user} <- Users.update_user(user, user_params) do
          render(conn, :show, user: updated_user)
        end

      nil ->
        conn
        |> put_status(:not_found)
        |> render(ManagerApiWeb.ErrorJSON, "404.json")
    end
  end

  defp update_user_params_manager(current_user, user, user_params) do
    if Map.has_key?(user_params, "role") and user.role == "Manager" and user_params["role"] == "Employee"  do
      change_manager_id_of_users(user.id, current_user)
      user_params
    else
      if Map.has_key?(user_params, "role") and user.role == "Employee" and user_params["role"] == "Manager" do
        Map.put(user_params, "manager_id", current_user.id)
      else
        Map.drop(user_params, ["role"])
      end
    end
  end

  defp update_user_params_non_manager(conn, current_user, user, user_params) do
    if current_user.id == user.id do
      user_params = Map.drop(user_params, ["role", "manager_id"])
      user_params
    else
      conn
      |> put_status(:unauthorized)
      |> render(ManagerApiWeb.ErrorJSON, "401.json")
    end
  end


  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    case Users.get_user(id) do
      %User{} = user ->
        case current_user.role do
          "GeneralManager" when user.society == current_user.society ->
            if user.role == "Manager" do
              change_manager_id_of_users(user.id, current_user)
            end
            delete_user(conn, user)
          _ ->
            if current_user.id == user.id do
              delete_user(conn, user)
            else
              conn
              |> put_status(:unauthorized)
              |> render(ManagerApiWeb.ErrorJSON, "401.json")
            end
        end
      nil ->
        conn
        |> put_status(:not_found)
        |> render(ManagerApiWeb.ErrorJSON, "404.json")
    end
  end


  defp delete_user(conn, user) do
    with {:ok, _} <- Users.delete_user(user) do
      send_resp(conn, :ok, "User #{user.username} has been successfully deleted")
    end
  end

  defp change_manager_id_of_users(id, current_user) do
    users_to_update = Users.list_users_by_manager_id(id)
    params = %{
      manager_id: current_user.id,
    }
    Enum.each(users_to_update, fn user ->
      Users.update_user(user, params)
    end)
  end

end
