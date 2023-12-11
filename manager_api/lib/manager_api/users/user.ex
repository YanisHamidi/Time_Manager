defmodule ManagerApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @optionnal_fields ([:id, :inserted_at, :updated_at, :manager_id])
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :role, :string
    field :society, :string
    belongs_to :user, ManagerApi.Users.User, foreign_key: :manager_id

    timestamps(type: :utc_datetime)
  end

  defp all_fieds do
    __MODULE__.__schema__(:fields)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, all_fieds())
    |> validate_required(all_fieds() -- @optionnal_fields)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email address")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
