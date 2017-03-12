defmodule Listen.Hivent.Consumers.UserSignedInTest do
  use ExUnit.Case, async: true

  import Listen.Factory

  alias Hivent.Event
  alias Listen.Hivent.Consumers.UserSignedIn
  alias Listen.Repo
  alias Listen.Accounts

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "when a user who already exists logs in" do
    setup do
      {:ok, %{
          user: insert(:user)
        }
      }
    end

    test "it updates the user's data", %{user: user} do
      event = %Event{
        payload: %{
          "user" => %{
            "id" => "#{user.id}",
            "name" => "New name",
            "email" => "new_email@foobar.com"
          }
        }
      }

      UserSignedIn.handle_events([{event, "queue"}], self(), %{})

      updated_user = Accounts.get_user!(user.id)

      assert updated_user.name == "New name"
      assert updated_user.email == "new_email@foobar.com"
    end
  end

  describe "when a user who does not exist logs in" do
    test "it creates a new user with the event payload" do
      uuid = Ecto.UUID.generate()
      event = %Event{
        payload: %{
          "user" => %{
            "id" => uuid,
            "name" => "New name",
            "email" => "new_email@foobar.com"
          }
        }
      }

      UserSignedIn.handle_events([{event, "queue"}], self(), %{})

      updated_user = Accounts.get_user!(uuid)

      assert updated_user.name == "New name"
      assert updated_user.email == "new_email@foobar.com"
    end
  end
end
