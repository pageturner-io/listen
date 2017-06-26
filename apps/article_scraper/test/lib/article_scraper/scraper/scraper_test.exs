defmodule ArticleScraper.ScraperTest do
  use ExUnit.Case, async: true

  alias ArticleScraper.Scraper
  alias ArticleScraper.Scraper.Article

  @url "https://example.com/2017/06/20/why-examples-are-useful"
  @id "ae6e7fe5617507dee222acbe51fe063d"
  @readability ArticleScraper.ReadabilityMock

  setup do
    article = %Article{id: @id, url: @url}
    augmented_article = @readability.summarize(@url)

    [article: article, expected: augmented_article]
  end

  test "Augments an %Article{} with title", %{article: article, expected: expected} do
    {:ok, augmented_article} = Scraper.scrape(article)

    assert augmented_article.title == expected.title
  end

  test "Augments an %Article{} with body text", %{article: article, expected: expected} do
    {:ok, augmented_article} = Scraper.scrape(article)

    assert augmented_article.text == expected.article_text
  end

  test "Augments an %Article{} with body html", %{article: article, expected: expected} do
    {:ok, augmented_article} = Scraper.scrape(article)

    assert augmented_article.html == expected.article_html
  end

  test "Augments an %Article{} with authors", %{article: article, expected: expected} do
    {:ok, augmented_article} = Scraper.scrape(article)

    assert augmented_article.authors == expected.authors
  end

  describe "with an unknown URL" do
    @url "https://example.com/2017/06/20/why-examples-are-useful"

    test "Augments an %Article with the source's domain name", %{article: article} do
      {:ok, augmented_article} = Scraper.scrape(%{article | url: @url })

      assert augmented_article.source.name == "example.com"
    end
  end

  describe "with a well-known URL" do
    @url "https://medium.com/2017/06/20/why-examples-are-useful"

    test "Augments an %Article with the source's readable name", %{article: article} do
      {:ok, augmented_article} = Scraper.scrape(%{article | url: @url })

      assert augmented_article.source.name == "Medium"
    end
  end
end
