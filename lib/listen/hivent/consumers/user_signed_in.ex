defmodule Listen.Hivent.Consumers.UserSignedIn do
  alias Listen.{User, Repo}

  use GenStage

  def start_link do
    {:ok, producer} = Hivent.Consumer.Stages.Producer.start_link("listen", ["user:signed_in"])
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

    case Repo.get(User, user["id"]) do
      nil  -> %User{id: user["id"]}
      user -> user
    end
    |> User.changeset(changes)
    |> Repo.insert_or_update!
  end
end
