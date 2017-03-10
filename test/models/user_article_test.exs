defmodule Listen.UserArticleTest do
  use Listen.ModelCase

  alias Listen.UserArticle

  @valid_attrs %{user_id: Ecto.UUID.generate(), article_id: Ecto.UUID.generate()}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserArticle.changeset(%UserArticle{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserArticle.changeset(%UserArticle{}, @invalid_attrs)
    refute changeset.valid?
  end
end
