defmodule ArticleScraper.Scraper do
  @moduledoc """
  The boundary for the Scraper system. Takes %Article{} structs and augments
  them with information scraped from their source url.
  """
  alias ArticleScraper.Scraper.Article

  @readability Application.get_env(:article_scraper, :readability)

  def scrape(%Article{} = article) do
    result = @readability.summarize(article.url)

    augmented = %Article{article |
      title: result.title,
      text: result.article_text,
      html: result.article_html,
      authors: result.authors,
      source: source_from_url(article.url),
      images: images_from_html(result.article_html)
    }

    {:ok, augmented}
  end

  defp source_from_url(url) do
    host = URI.parse(url).host
    name = case human_name_for_host(host) do
      nil -> host
      name -> name
    end

    %Article.Source{name: name}
  end

  defp human_name_for_host(host) do
    case Application.fetch_env(:article_scraper, :well_known_domains) do
      {:ok, domains} -> domains[host]
      :error -> nil
    end
  end

  defp images_from_html(html) do
    Readability.article(html, [clean_conditionally: false])
    |> Floki.find("img")
    |> Floki.attribute("src")
  end
end
