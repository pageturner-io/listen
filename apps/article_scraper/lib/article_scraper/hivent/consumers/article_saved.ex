defmodule ArticleScraper.Hivent.Consumers.ArticleSaved do

  @topic "listen:article:saved"
  @name "article_scraper_article_saved"
  @partition_count 2

  alias Hivent.Event

  use Hivent.Consumer

  def process(%Event{} = _event) do
    :ok
  end
end
