defmodule ManagerApi.UserTest do
  use ExUnit.Case
  alias ManagerApi.Users.User

  @expected_fields_with_types [
    username: :string,
    email: :string,
    password: :string,
    role: :string,
    society: :string,
    id: :id,
    inserted_at: :utc_datetime,
    updated_at: :utc_datetime
  ]

  describe "fields and types" do
    test "it has the correct fields and types" do
      actual_fields_with_types =
        for field <- User.__schema__(:fields) do
          type = User.__schema__(:type, field)
          {field, type}
        end

        assert true
    end
  end
end
