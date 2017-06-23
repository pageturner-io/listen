defmodule Listen.AccountsTest do
  use Listen.DataCase

  alias Listen.Accounts
  alias Listen.Accounts.User

  @create_attrs %{id: Ecto.UUID.generate(), name: "some name", email: "foo@bar.com"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{id: nil}

  def fixture(:user, attrs \\ @create_attrs) do
    {:ok, user} = Accounts.create_user(attrs)
    user
  end

  test "get_user! returns the user with given id" do
    user = fixture(:user)
    assert Accounts.get_user!(user.id) == user
  end

  test "get_user returns the user with given id" do
    user = fixture(:user)
    assert Accounts.get_user(user.id) == user
  end

  test "get_user returns nil if the user with given id does not exist" do
    assert Accounts.get_user(Ecto.UUID.generate()) == nil
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Accounts.create_user(@create_attrs)

    assert user.name == "some name"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = fixture(:user)
    assert {:ok, user} = Accounts.update_user(user, @update_attrs)
    assert %User{} = user

    assert user.name == "some updated name"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = fixture(:user)
    assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    assert user == Accounts.get_user!(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = fixture(:user)
    assert {:ok, %User{}} = Accounts.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = fixture(:user)
    assert %Ecto.Changeset{} = Accounts.change_user(user)
  end
end
