#defmodule ManagerApiWeb.WorkingTimeControllerTest do
#  use ManagerApiWeb.ConnCase
#
#  import ManagerApi.WorkingTimesFixtures
#
#  alias ManagerApi.WorkingTimes.WorkingTime
#
#  @create_attrs %{
#    start: "some start",
#    end: "some end"
#  }
#  @update_attrs %{
#    start: "some updated start",
#    end: "some updated end"
#  }
#  @invalid_attrs %{start: nil, end: nil}
#
#  setup %{conn: conn} do
#    {:ok, conn: put_req_header(conn, "accept", "application/json")}
#  end
#
#  describe "index" do
#    test "lists all workingtimes", %{conn: conn} do
#      conn = get(conn, ~p"/api/workingtimes")
#      assert json_response(conn, 200)["data"] == []
#    end
#  end
#
#  describe "create working_time" do
#    test "renders working_time when data is valid", %{conn: conn} do
#      conn = post(conn, ~p"/api/workingtimes", working_time: @create_attrs)
#      assert %{"id" => id} = json_response(conn, 201)["data"]
#
#      conn = get(conn, ~p"/api/workingtimes/#{id}")
#
#      assert %{
#               "id" => ^id,
#               "end" => "some end",
#               "start" => "some start"
#             } = json_response(conn, 200)["data"]
#    end
#
#    test "renders errors when data is invalid", %{conn: conn} do
#      conn = post(conn, ~p"/api/workingtimes", working_time: @invalid_attrs)
#      assert json_response(conn, 422)["errors"] != %{}
#    end
#  end
#
#  describe "update working_time" do
#    setup [:create_working_time]
#
#    test "renders working_time when data is valid", %{conn: conn, working_time: %WorkingTime{id: id} = working_time} do
#      conn = put(conn, ~p"/api/workingtimes/#{working_time}", working_time: @update_attrs)
#      assert %{"id" => ^id} = json_response(conn, 200)["data"]
#
#      conn = get(conn, ~p"/api/workingtimes/#{id}")
#
#      assert %{
#               "id" => ^id,
#               "end" => "some updated end",
#               "start" => "some updated start"
#             } = json_response(conn, 200)["data"]
#    end
#
#    test "renders errors when data is invalid", %{conn: conn, working_time: working_time} do
#      conn = put(conn, ~p"/api/workingtimes/#{working_time}", working_time: @invalid_attrs)
#      assert json_response(conn, 422)["errors"] != %{}
#    end
#  end
#
#  describe "delete working_time" do
#    setup [:create_working_time]
#
#    test "deletes chosen working_time", %{conn: conn, working_time: working_time} do
#      conn = delete(conn, ~p"/api/workingtimes/#{working_time}")
#      assert response(conn, 204)
#
#      assert_error_sent 404, fn ->
#        get(conn, ~p"/api/workingtimes/#{working_time}")
#      end
#    end
#  end
#
#  defp create_working_time(_) do
#    working_time = working_time_fixture()
#    %{working_time: working_time}
#  end
#end
