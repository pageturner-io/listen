defmodule Web.Hivent.Consumers.UserSignedInTest do
  use ExUnit.Case, async: true

  import Web.Factory

  alias Hivent.Event
  alias Web.Hivent.Consumers.UserSignedIn
  alias Web.{User, Repo}

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

      updated_user = Repo.get(User, user.id)

      assert updated_user.name == "New name"
      assert updated_user.email == "new_email@foobar.com"
    end
  end

  describe "when a user who does not exist logs in" do
    test "it creates a new user with the event payload" do
      event = %Event{
        payload: %{
          "user" => %{
            "id" => "25",
            "name" => "New name",
            "email" => "new_email@foobar.com"
          }
        }
      }

      UserSignedIn.handle_events([{event, "queue"}], self(), %{})

      updated_user = Repo.get(User, 25)

      assert updated_user.name == "New name"
      assert updated_user.email == "new_email@foobar.com"
    end
  end
end
