defmodule Web.Auth.GuardianSerializer do
  @moduledoc """
  The Token serializer used by Guardian to encode and
  decode resources into and from JWTs.
  """

  @behaviour Guardian.Serializer

  alias Web.Repo
  alias Web.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id) do
    case Repo.get(User, id) do
      nil  ->
        changeset = User.changeset(%User{}, %{id: id})
        Repo.insert(changeset)
      user -> {:ok, user}
    end
  end
  def from_token(_), do: {:error, "Unknown resource type"}

end
