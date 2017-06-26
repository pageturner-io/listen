defmodule ArticleScraper.Scraper do
  @moduledoc """
  The boundary for the Scraper system. Takes %Article{} structs and augments
  them with information scraped from their source url.
  """
  alias ArticleScraper.Scraper.Article
  alias ArticleScraper.Scraper.Article.{Author, Image, Source}

  @readability Application.get_env(:article_scraper, :readability)
  @hivent Application.get_env(:listen, :hivent)

  def scrape(%Article{} = article) do
    summary = @readability.summarize(article.url)

    augmented = %Article{article |
      title: summary.title,
      text: summary.article_text,
      html: summary.article_html,
      authors: authors_from_summary(summary),
      source: source_from_url(article.url),
      images: images_from_html(summary.article_html)
    }

    @hivent.emit("scraper:article:scraped", %{article: augmented}, %{version: 1})

    {:ok, augmented}
  end

  defp source_from_url(url) do
    host = URI.parse(url).host
    name = case human_name_for_host(host) do
      nil -> host
      name -> name
    end

    %Source{name: name}
  end

  defp human_name_for_host(host) do
    case Application.fetch_env(:article_scraper, :well_known_domains) do
      {:ok, domains} -> domains[host]
      :error -> nil
    end
  end

  defp authors_from_summary(summary), do: Enum.map(summary.authors, fn (author) -> %Author{name: author} end)

  defp images_from_html(html) do
    Readability.article(html, [clean_conditionally: false])
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> Enum.map(fn (src) -> %Image{url: src} end)
  end
end
