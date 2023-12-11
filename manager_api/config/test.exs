import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :manager_api, ManagerApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "manager_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :manager_api, ManagerApiWeb.Endpoint,
  http: [port: 4002],
  secret_key_base: "XA40B4Za9EtSSIkaDLLzhij1vrkNM78z8s1UFiJPiu785LjULhZ5qsY2IHjnWhhz",
  server: false

# In test we don't send emails.
config :manager_api, ManagerApi.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
