defmodule Listen.Hivent.Consumers.ArticleScrapedTest do
  use ExUnit.Case

  import Listen.Factory
  import Listen.TimeHelper

  alias Listen.{ReadingList, Repo}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

    article = insert(:article)

    [article: article]
  end

  test "it updates the article with scraped data", %{article: article} do
    payload = %{
      article: %{
        id: article.id,
        url: article.url,
        title: "A title",
        text: "Lorem ipsum",
        html: "<p>Lorem ipsum</p>",
        authors: [%{name: "An author"}],
        source: %{name: "The Internet"},
        images: [%{url: "https://example.com/img.jpg"}]
      }
    }

    Hivent.emit("scraper:article:scraped", payload, %{version: 1})

    wait_until 5000, fn ->
      updated_article = ReadingList.get_article!(article.id, nil)

      author_names = Enum.map(updated_article.authors, fn (author) -> %{name: author.name} end)
      image_urls = Enum.map(updated_article.images, fn (image) -> %{url: image.url} end)

      assert updated_article.title == payload.article.title
      assert updated_article.text == payload.article.text
      assert updated_article.html == payload.article.html
      assert author_names == payload.article.authors
      assert updated_article.source.name == payload.article.source.name
      assert image_urls == payload.article.images
    end
  end
end
