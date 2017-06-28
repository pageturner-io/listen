defmodule Listen.AuthorFactory do
  defmacro __using__(_opts) do
    quote do
      alias Listen.ReadingList.Author

      def author_factory do
        %Author{name: "Jane Smith"}
      end
    end
  end
end
