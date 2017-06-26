defmodule Listen.Hivent.Consumers.UserSignedInTest do
  use ExUnit.Case

  import Listen.Factory
  import Listen.TimeHelper

  alias Listen.Repo
  alias Listen.Accounts

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

    :ok
  end

  describe "when a user who already exists logs in" do
    setup do
      {:ok, %{
          user: insert(:user)
        }
      }
    end

    test "it updates the user's data", %{user: user} do
      payload = %{
        "user" => %{
          "id" => "#{user.id}",
          "name" => "New name",
          "email" => "new_email@foobar.com"
        }
      }

      Hivent.emit("identity:user:signed_in", payload, %{version: 1})

      wait_until 5000, fn ->
        updated_user = Accounts.get_user!(user.id)

        assert updated_user.name == "New name"
        assert updated_user.email == "new_email@foobar.com"
      end
    end
  end

  describe "when a user who does not exist logs in" do
    test "it creates a new user with the event payload" do
      uuid = Ecto.UUID.generate()

      payload = %{
        "user" => %{
          "id" => uuid,
          "name" => "New name",
          "email" => "new_email@foobar.com"
        }
      }

      Hivent.emit("identity:user:signed_in", payload, %{version: 1})

      wait_until 5000, fn ->
        updated_user = Accounts.get_user!(uuid)

        assert updated_user.name == "New name"
        assert updated_user.email == "new_email@foobar.com"
      end
    end
  end
end
