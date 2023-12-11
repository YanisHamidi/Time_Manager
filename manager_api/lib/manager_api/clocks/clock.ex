defmodule ManagerApi.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset


  schema "clocks" do
    field :status, :boolean
    field :time, :utc_datetime
    belongs_to :user, ManagerApi.Users.User, foreign_key: :user_id


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status])
  end
end
