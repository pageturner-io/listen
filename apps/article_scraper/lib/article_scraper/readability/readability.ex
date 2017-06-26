defmodule ArticleScraper.Readability do
  @callback summarize(url :: String.t) :: %Readability.Summary{}
end
