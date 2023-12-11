defmodule ManagerApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ManagerApiWeb.Telemetry,
      ManagerApi.Repo,
      {DNSCluster, query: Application.get_env(:manager_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ManagerApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ManagerApi.Finch},
      # Start a worker by calling: ManagerApi.Worker.start_link(arg)
      # {ManagerApi.Worker, arg},
      # Start to serve requests, typically the last entry
      ManagerApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ManagerApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ManagerApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
