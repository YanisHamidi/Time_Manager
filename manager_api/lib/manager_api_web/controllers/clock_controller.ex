defmodule ManagerApiWeb.ClockController do
  use ManagerApiWeb, :controller

  alias ManagerApi.Clocks
  alias ManagerApi.Clocks.Clock
  alias ManagerApiWeb.Plugs.ClocksAuthorization

  plug ClocksAuthorization


  action_fallback ManagerApiWeb.FallbackController


  def index(conn, %{"userID" => user_id}) do
    current_user = conn.assigns[:current_user]
    current_user_id_str = Integer.to_string(current_user.id)
    case Clocks.get_last_clock(user_id) do
      nil when current_user_id_str == user_id ->
        send_resp(conn, :no_content, "")
      clock when current_user_id_str == user_id->
        render(conn, :index, clocks: [clock])
      _ ->
        conn
          |> put_status(:unauthorized)
          |> render(ManagerApiWeb.ErrorJSON, "401.json")
      end
  end


  def create(conn, %{"clock" => clock_params, "userID" => user_id}) do
    current_user = conn.assigns[:current_user]
    new_clock_status = Map.get(clock_params, "status")
    new_clock_params = Map.put(clock_params, "user_id", user_id)

    case ManagerApi.Users.get_user(user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(ManagerApiWeb.ErrorJSON, "404.json")

      user when current_user.id == user.id->
        case Clocks.get_previous_clock_by_user_id(user_id) do
          {:ok, previous_clock} when new_clock_status == true and (previous_clock == nil or previous_clock.status == false) ->

            case Clocks.create_clock(new_clock_params) do
              {:ok, %Clock{} = new_clock} ->
                conn
                |> put_status(:created)
                |> put_resp_header("location", "/api/clocks/#{user_id}")
                |> render(:show, clock: new_clock)

              _ ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(ManagerApiWeb.ErrorJSON, "error.json")
            end

          {:ok, previous_clock} when new_clock_status == false and previous_clock.status == true ->
            # Create the new clock and a working time
            create_clock_with_working_time(conn, new_clock_params, user_id, previous_clock)
            _->
              conn
                  |> put_status(:unprocessable_entity)
                  |> render(ManagerApiWeb.ErrorJSON, "error.json")
        end
        _ ->
          conn
          |> put_status(:unauthorized)
          |> render(ManagerApiWeb.ErrorJSON, "401.json")
    end

  end


  defp create_clock_with_working_time(conn, new_clock_params, user_id, previous_clock) do
    case Clocks.create_clock(new_clock_params) do
      {:ok, %Clock{} = new_clock} ->
        working_time_start = previous_clock.time
        working_time_end = new_clock.time
        working_time_seconds = DateTime.diff(working_time_end, working_time_start, :second)
        ManagerApiWeb.WorkingTimeController.create(conn, %{
          "working_time" => %{
            "start" => working_time_start,
            "end" => working_time_end,
            "working_time_seconds" => working_time_seconds
          },
          "userID" => user_id,
          "no_show" => true
        })

        conn
        |> put_status(:created)
        |> put_resp_header("location", "/api/clocks/#{user_id}")
        |> render(:show, clock: new_clock)


      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ManagerApiWeb.ErrorJSON, "error.json")
    end
  end



  def show(conn, %{"userID" => user_id, "id" => id}) do
    if id == "all" do
      clocks = Clocks.list_clocks(user_id)
      render(conn, :index, clocks: clocks)
    else
      case Clocks.get_clock_by_user_id(id, user_id) do
        {:ok, clock} ->
          render(conn, :show, clock: clock)

        {:error, _} ->
          conn
          |> put_status(:not_found)
          |> render(ManagerApiWeb.ErrorJSON, "404.json")
      end
    end
  end
end
