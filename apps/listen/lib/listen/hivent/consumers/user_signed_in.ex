defmodule Listen.Hivent.Consumers.UserSignedIn do
  alias Listen.Accounts

  use GenStage

  def start_link do
    {:ok, producer} = Hivent.Consumer.Stages.Producer.start_link("listen", ["identity:user:signed_in"])
    GenStage.start_link(__MODULE__, producer)
  end

  def init(producer) do
    {:consumer, %{}, subscribe_to: [{producer, min_demand: 1, max_demand: 10}]}
  end

  def handle_events(events, _from, state) do
    for {event, _queue} <- events do
      create_or_update(event.payload["user"])
    end

    # As a consumer we never emit events
    {:noreply, [], state}
  end

  defp create_or_update(user) do
    changes = %{
      email: user["email"],
      name: user["name"]
    }

    case Accounts.get_user(user["id"]) do
      nil  ->
        with {:ok, user} <- Accounts.create_user(%{id: user["id"]}) do
          user
        end
      user -> user
    end
    |> Accounts.update_user(changes)
  end
end
