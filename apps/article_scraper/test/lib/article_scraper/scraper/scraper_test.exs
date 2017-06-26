defmodule ArticleScraper.ScraperTest do
  use ExUnit.Case, async: true

  alias ArticleScraper.Scraper
  alias ArticleScraper.Scraper.Article

  @url "https://example.com"
  @id "ae6e7fe5617507dee222acbe51fe063d"

  setup do
    article = %Article{url: @url}

    [article: article]
  end

  test "Augments an %Article{} with body text", %{article: article} do
    {:ok, augmented_article} = Scraper.scrape(article)

    assert augmented_article.text == "example text"
  end
end
