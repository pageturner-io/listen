defmodule Listen.Hivent.Consumers.ArticleScraped do
  @topic "scraper:article:scraped"
  @name "listen_article_scraped"
  @partition_count 2

  use Hivent.Consumer

  alias Listen.ReadingList

  def process(%Hivent.Event{} = event) do
    article = ReadingList.get_article!(event.payload["article"]["id"])

    case ReadingList.update_article(article, event.payload["article"]) do
      {:ok, _article} -> :ok
      {:error, _changeset} -> {:error, "Failed to update article"}
    end
  end
end
