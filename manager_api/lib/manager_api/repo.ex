defmodule ManagerApi.Repo do
  use Ecto.Repo,
    otp_app: :manager_api,
    adapter: Ecto.Adapters.Postgres
end
