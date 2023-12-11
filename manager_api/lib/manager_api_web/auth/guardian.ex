defmodule ManagerApiWeb.Auth.Guardian do
  use Guardian, otp_app: :manager_api
  alias ManagerApi.Users

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Users.get_user!(id) do
      nil ->  {:error, :no_account}
      resource -> {:ok, resource}
    end
  end

  def resource_for_claims(_) do
    {:error, :no_sub_provided}
  end

  def authenticate(email, password) do
    case Users.get_user_by_email(email) do
      nil -> {:error, :no_account}
      user ->
        case validate_password(password, user.password) do
          true -> create_token(user)
          false -> {:error, :unauthorized}
        end
    end
  end

  defp validate_password(hash_password, password) do
    Bcrypt.verify_pass(hash_password, password)
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
