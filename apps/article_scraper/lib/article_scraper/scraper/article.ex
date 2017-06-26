defmodule ArticleScraper.Scraper.Article do
  @moduledoc """
  Defines an Article.
  """
  alias __MODULE__
  @derive [Poison.Encoder]

  defmodule Image do
    @moduledoc false
    defstruct [:url]
  end

  defmodule Source do
    @moduledoc false
    defstruct [:name, image: Article.Image.__struct__]
  end

  defmodule Author do
    @moduledoc false
    defstruct [:name, image: Article.Image.__struct__]
  end

  defstruct [
    :id,
    :url,
    :title,
    :text,
    :html,
    images: [Image.__struct__],
    source: Source.__struct__,
    authors: [Author.__struct__]
  ]
end
