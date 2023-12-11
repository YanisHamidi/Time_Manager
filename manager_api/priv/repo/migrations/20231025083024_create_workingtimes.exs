defmodule ManagerApi.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def change do
    create table(:workingtimes) do
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all)
      add :working_time_seconds, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:workingtimes, [:user_id])
  end
end
