defmodule Listen.Hivent.Consumers.UserSignedIn do
  alias Listen.Accounts

  @topic "identity:user:signed_in"
  @name "listen_user_signed_in"
  @partition_count 2

  use Hivent.Consumer

  def process(%Hivent.Event{} = event) do
    case create_or_update(event.payload["user"]) do
      {:ok, _user} -> :ok
      {:error, _changeset} -> {:error, "Failed to create/update user"}
    end
  end

  defp create_or_update(changeset) do
    changes = %{
      email: changeset["email"],
      name: changeset["name"]
    }

    case Accounts.get_user(changeset["id"]) do
      nil  ->
        with {:ok, user} <- Accounts.create_user(%{id: changeset["id"]}) do
          user
        end
      user -> user
    end
    |> Accounts.update_user(changes)
  end
end
