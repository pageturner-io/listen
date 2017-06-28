defmodule Listen.ArticleFactory do
  defmacro __using__(_opts) do
    quote do
      alias Listen.ReadingList.Article

      def article_factory do
        %Article{url: "https://example.com"}
      end

      def with_scraped_data(article = %Article{}) do
        data = %{
          title: "A title",
          text: "Lorem ipsum",
          html: "<p>Lorem ipsum</p>",
          authors: build_list(1, :author),
          source: build(:source),
          images: build_list(1, :image)
        }

        Map.merge(article, data)
      end
    end
  end
end
