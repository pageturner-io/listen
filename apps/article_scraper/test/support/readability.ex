defmodule ArticleScraper.ReadabilityMock do
  @behaviour ArticleScraper.Readability

  alias ArticleScraper.Readability.Result

  def summarize(_url) do
    %Result{
      title: "Example title",
      article_text: "Example text",
      article_html: "<p>Example text</p>",
      authors: ["Test Author 1", "Test Author 2"]
    }
  end
end
