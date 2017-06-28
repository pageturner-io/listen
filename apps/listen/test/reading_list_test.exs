defmodule Listen.ReadingListTest do
  use Listen.DataCase

  import Listen.Factory

  alias Listen.ReadingList
  alias Listen.ReadingList.Article

  @hivent Application.get_env(:listen, :hivent)

  @create_attrs %{
    url: "https://example.com",
    title: "A title",
    text: "Some text",
    html: "<p>Some text</p>",
    authors: [
      %{name: "An author"}
    ],
    source: %{name: "The Source"},
    images: [
      %{url: "https://example.com/img.jpg"}
    ],
  }
  @invalid_attrs %{url: nil}

  setup do
    @hivent.clear()

    user = insert(:user)
    other_user = insert(:user)

    {:ok, %{
      user: user,
      other_user: other_user
    }}
  end

  def fixture(:article, user, attrs \\ @create_attrs) do
    {:ok, article} = ReadingList.create_article(attrs, user)
    article |> Repo.preload([:authors, :images, :source])
  end

  @tag :wip
  test "list_articles/1 returns all articles for the given user", %{user: user, other_user: other_user} do
    article_1 = fixture(:article, user, %{@create_attrs | url: "https://foo.bar"})
    article_2 = fixture(:article, user, %{@create_attrs | url: "https://bar.qux"})
    fixture(:article, other_user, %{@create_attrs | url: "https://zoo.log"})

    articles = ReadingList.list_articles(user)
    |> Enum.map(fn (article) -> Repo.preload(article, :users) end)

    assert articles == [article_1, article_2]
  end

  test "get_article!/2 returns the article with given id", %{user: user} do
    article = fixture(:article, user)
    assert ReadingList.get_article!(article.id, user) |> Repo.preload(:users) == article
  end

  test "get_article/2 returns the article with given id", %{user: user} do
    article = fixture(:article, user)
    assert ReadingList.get_article(article.id, user) |> Repo.preload(:users) == article
  end

  test "get_article/2 returns nil if the article with the given id does not exist", %{user: user} do
    assert ReadingList.get_article(Ecto.UUID.generate(), user) == nil
  end

  test "create_article/2 with valid data creates an Article", %{user: user} do
    {:ok, %Article{} = article} = ReadingList.create_article(@create_attrs, user)

    author_names = Enum.map(article.authors, fn (author) -> %{name: author.name} end)
    image_urls = Enum.map(article.images, fn (image) -> %{url: image.url} end)

    assert article.url == @create_attrs.url
    assert article.title == @create_attrs.title
    assert article.text == @create_attrs.text
    assert article.html == @create_attrs.html
    assert author_names == @create_attrs.authors
    assert article.source.name == @create_attrs.source.name
    assert image_urls == @create_attrs.images
  end

  describe "when the article does not yet exist" do
    test "create_article/2 with valid data creates an Article and associates it with the given user", %{user: user} do
      {:ok, %Article{} = article} = ReadingList.create_article(@create_attrs, user)

      assert Enum.member?(article.users, user)
    end

    test "create_article/2 with valid data publishes a Hivent event", %{user: user} do
      {:ok, %Article{} = article} = ReadingList.create_article(@create_attrs, user)

      assert @hivent.include?(
        %{user: %{id: user.id}, article: %{id: article.id, url: article.url}},
        %{name: "listen:article:saved"}
      )
    end
  end

  describe "when the article already exists" do
    test "create_article/2 with valid data only associates the article with the user", %{user: user, other_user: other_user} do
      article = fixture(:article, other_user)

      {:ok, %Article{} = new_article} = ReadingList.create_article(%{url: article.url}, user)

      assert article.id == new_article.id
      assert Enum.member?(new_article.users, user)
    end

    test "create_article/2 with valid data publishes a Hivent event", %{user: user} do
      {:ok, %Article{} = new_article} = ReadingList.create_article(@create_attrs, user)

      assert @hivent.include?(
        %{user: %{id: user.id}, article: %{id: new_article.id, url: new_article.url}},
        %{name: "listen:article:saved"}
      )
    end
  end

  test "create_article/2 with invalid data returns error changeset", %{user: user} do
    assert {:error, %Ecto.Changeset{}} = ReadingList.create_article(@invalid_attrs, user)
  end

  test "create_article/2 with invalid data does not publish a Hivent event", %{user: user} do
    ReadingList.create_article(@invalid_attrs, user)

    assert Enum.empty?(@hivent.Emitter.Cache.all)
  end

  test "remove_article/2 removes the association with the user but not the article", %{user: user} do
    article = fixture(:article, user)

    {:ok, %Article{}} = ReadingList.remove_article(article, user)

    updated_article = ReadingList.get_article!(article.id, user) |> Repo.preload(:users)

    assert updated_article
    refute Enum.member?(updated_article.users, user)
  end
end
