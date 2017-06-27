defmodule ArticleScraper.ReadabilityMock do
  @behaviour ArticleScraper.Readability

  alias Readability.Summary

  defmodule Helpers do
    def url_with_images, do: "https://example.com/with_images"
  end

  def summarize("https://example.com/with_images") do
    %Summary{
      title: "Example title",
      article_text: "Example text",
      article_html: "<p>Example text with images: <img src=\"https://example.com/img.jpg\"/></p>",
      authors: ["Test Author 1", "Test Author 2"]
    }
  end
  def summarize(_url) do
    %Summary{
      title: "Example title",
      article_text: "Example text",
      article_html: "<p>Example text</p>",
      authors: ["Test Author 1", "Test Author 2"]
    }
  end
end
