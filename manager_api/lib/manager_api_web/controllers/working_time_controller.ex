defmodule ManagerApiWeb.WorkingTimeController do
  use ManagerApiWeb, :controller

  alias ManagerApi.WorkingTimes
  alias ManagerApi.WorkingTimes.WorkingTime
  alias ManagerApiWeb.Plugs.WorkingTimesAuthorization


  plug WorkingTimesAuthorization

  action_fallback ManagerApiWeb.FallbackController

  def index(conn, %{"userID" => user_id} = params) do
    if Map.has_key?(params, "start_date") and Map.has_key?(params, "end_date") do
      workingtimes = WorkingTimes.list_workingtimes(user_id, params["start_date"], params["end_date"])
      render(conn, :index, workingtimes: workingtimes)
    else
      workingtimes =WorkingTimes.list_workingtimes(user_id)
      render(conn, :index, workingtimes: workingtimes)
    end
  end

  def index(conn, params) do
    current_user = conn.assigns[:current_user]
    workingtimes =
      case current_user.role do
        "GeneralManager" ->
          if Map.has_key?(params, "start_date") and Map.has_key?(params, "end_date") do
            WorkingTimes.list_working_times_by_society(current_user.society, params["start_date"], params["end_date"])
          else
            WorkingTimes.list_working_times_by_society(current_user.society)
          end
        "Manager" ->
          if Map.has_key?(params, "start_date") and Map.has_key?(params, "end_date") do
            WorkingTimes.list_working_times_by_manager_id(current_user.id, params["start_date"], params["end_date"])
          else
            WorkingTimes.list_working_times_by_manager_id(current_user.id)
          end
          _ ->
            conn
          |> put_status(:unauthorized)
          |> render(ManagerApiWeb.ErrorJSON, "401.json")
      end

    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"working_time" => working_time_params, "userID" => user_id, "no_show" => no_show} = _params) do
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(Map.put(working_time_params, "user_id", user_id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/workingtimes/#{user_id}")
      |> render_or_not(:show, working_time, no_show)
    end
  end

  defp render_or_not(conn, :show, data, false) do
    conn
    |> render(:show, data: data)
  end

  defp render_or_not(conn, _template, _data, true) do
    conn
  end




  def show(conn, %{"userID" => user_id, "id" => id}) do
    if id == "all" do
      working_times = WorkingTimes.list_workingtimes(user_id)
      render(conn, :index, workingtimes: working_times)
    else
      case WorkingTimes.get_working_time_by_user_id(id, user_id) do
        {:ok, working_time} ->
          render(conn, :show, working_time: working_time)

        {:error, _} ->
          conn
          |> put_status(:not_found)
          |> render(ManagerApiWeb.ErrorJSON, "404.json")
      end
    end
  end



  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
