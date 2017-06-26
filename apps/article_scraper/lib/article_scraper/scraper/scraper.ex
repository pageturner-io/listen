defmodule ArticleScraper.Scraper do
  @moduledoc """
  The boundary for the Scraper system. Takes %Article{} structs and augments
  them with information scraped from their source url.
  """
  alias ArticleScraper.Scraper.Article

  @readability Application.get_env(:article_scraper, :readability)

  def scrape(%Article{} = article) do

  end
end
