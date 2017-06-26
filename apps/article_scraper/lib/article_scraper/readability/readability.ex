defmodule ArticleScraper.Readability do
  defmodule Result do
    @moduledoc false

    defstruct [:title, :authors, :article_html, :article_text]
  end

  @callback summarize(url :: String.t) :: %Result{}
end
