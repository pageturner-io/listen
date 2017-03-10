defmodule Listen.UserTest do
  use Listen.ModelCase

  alias Listen.User

  @valid_attrs %{email: "some content", name: "some content"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end
end
