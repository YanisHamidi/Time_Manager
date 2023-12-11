defmodule ManagerApiWeb.Plugs.WorkingTimesAuthorization do
  import Plug.Conn

  alias ManagerApiWeb.Auth.Guardian


  def init(_opts), do: %{}

  def call(conn, _opts) do
    case Guardian.decode_and_verify(get_token(conn)) do
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
        conn

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
