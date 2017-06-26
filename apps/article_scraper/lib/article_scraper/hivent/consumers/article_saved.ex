defmodule ArticleScraper.Hivent.Consumers.ArticleSaved do

  @topic "listen:article:saved"
  @name "article_scraper_article_saved"
  @partition_count 2

  alias Hivent.Event
  alias ArticleScraper.Scraper.Article

  use Hivent.Consumer

  def process(%Event{} = event) do
    article = %Article{
      id: event.payload["article"]["id"],
      url: event.payload["article"]["url"]
    }

    {:ok, _scraped_article} = ArticleScraper.scrape(article)

    :ok
  end
end
