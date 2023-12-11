defmodule ManagerApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password, :string
      add :role, :string
      add :society, :string
      add :manager_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
    create unique_index(:users, [:email]) #create one email per user
  end
end
