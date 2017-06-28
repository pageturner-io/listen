defmodule Listen.SourceFactory do
  defmacro __using__(_opts) do
    quote do
      alias Listen.ReadingList.Source

      def source_factory do
        %Source{name: "Medium"}
      end
    end
  end
end
