defmodule ManagerApiWeb.Plugs.UsersAuthorization do
  import Plug.Conn

  alias ManagerApiWeb.Auth.Guardian


  def init(_opts), do: %{}

  def call(conn, _opts) do
    token = get_token(conn)
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        user_id = claims["sub"]
        user = ManagerApi.Users.get_user!(user_id)
        conn =
          assign(conn, :current_user, %{
            id: user.id,
            role: user.role,
            society: user.society,
            manager_id: user.manager_id
          })
        case conn.private[:phoenix_action] do
          :index  ->
            conn
          :show  ->
            conn
          :create when user.role in ["GeneralManager", "Manager"] ->
            conn
          :update ->
            conn
          :delete ->
            conn
          :demote when user.role in ["GeneralManager"] ->
            conn
          _ ->
            conn
            |> put_status(:forbidden)
            |> send_resp(403, "Access forbidden")
            |> halt()
        end

        {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> send_resp(401, "Unauthorized")
        |> halt()
    end
  end

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      [token | _] ->
        token
        |> String.replace("Bearer ", "")  # Remove the "Bearer " prefix if present
      _ ->
        nil
    end
  end
end
