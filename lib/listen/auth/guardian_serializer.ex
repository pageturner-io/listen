defmodule Listen.Auth.GuardianSerializer do
  @moduledoc """
  The Token serializer used by Guardian to encode and
  decode resources into and from JWTs.
  """

  @behaviour Guardian.Serializer

  alias Listen.Accounts
  alias Accounts.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id) do
    case Accounts.get_user!(id) do
      nil  -> Accounts.create_user(%{id: id})
      user -> {:ok, user}
    end
  end
  def from_token(_), do: {:error, "Unknown resource type"}

end
