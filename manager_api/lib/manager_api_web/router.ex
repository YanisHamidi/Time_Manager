defmodule ManagerApiWeb.Router do
  use ManagerApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ManagerApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authorization_users do
    plug ManagerApiWeb.Plugs.UsersAuthorization
  end

  pipeline :authorization_clocks do
    plug ManagerApiWeb.Plugs.ClocksAuthorization
  end

  pipeline :authorization_working_times do
    plug ManagerApiWeb.Plugs.WorkingTimesAuthorization
  end


  scope "/", ManagerApiWeb do
    pipe_through :browser

    get "/", PageController, :home
  end


  scope "/api", ManagerApiWeb do
    pipe_through :api


    resources "/users", UserController
    post "/users/sign_in", UserController, :sign_in
    post "/users/sign_up", UserController, :sign_up
    post "/users/verify_session", UserController, :verify_session


    get "/clocks/:userID", ClockController, :index
    post "/clocks/:userID", ClockController, :create

    resources "/workingtimes/:userID", WorkingTimeController
    resources "/workingtimes/", WorkingTimeController, only: [:index]  do
      pipe_through [:authorization_working_times]
    end

    delete "/workingtimes/:id", WorkingTimeController, :delete
    put "/workingtimes/:id", WorkingTimeController, :update


  end

  # Other scopes may use custom stacks.
  # scope "/api", ManagerApiWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:manager_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ManagerApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
