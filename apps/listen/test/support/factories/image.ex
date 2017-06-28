defmodule Listen.ImageFactory do
  defmacro __using__(_opts) do
    quote do
      alias Listen.ReadingList.Image

      def image_factory do
        %Image{url: sequence(:image_id, &"https://example.com/img#{&1}.jpg")}
      end
    end
  end
end
