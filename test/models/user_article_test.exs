defmodule Web.UserArticleTest do
  use Web.ModelCase

  alias Web.UserArticle

  @valid_attrs %{}
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
