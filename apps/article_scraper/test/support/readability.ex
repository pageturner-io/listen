defmodule ArticleScraper.ReadabilityMock do
  @behaviour ArticleScraper.Readability

  alias Readability.Summary

  def summarize(_url) do
    %Summary{
      title: "Example title",
      article_text: "Example text",
      article_html: "<p>Example text</p>",
      authors: ["Test Author 1", "Test Author 2"]
    }
  end
end
