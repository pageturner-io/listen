defmodule Listen.ArticleFactory do
  defmacro __using__(_opts) do
    quote do
      alias Listen.ReadingList.Article

      def article_factory do
        %Article{
          url: "https://example.com"
        }
      end
    end
  end
end
