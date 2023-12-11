defmodule ManagerApi.WorkingTimes.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    belongs_to :user, ManagerApi.Users.User, foreign_key: :user_id
    field :working_time_seconds, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user_id, :working_time_seconds])
    |> validate_required([:start, :end])
  end
end
