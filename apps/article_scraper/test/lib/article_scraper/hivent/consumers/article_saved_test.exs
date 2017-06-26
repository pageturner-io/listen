defmodule ArticleScraper.Hivent.Consumers.ArticleSavedTest do
  use ExUnit.Case

  import TimeHelper

  @hivent Application.get_env(:listen, :hivent)

  setup do
    payload = %{
      "article" => %{
        "id" => "ae6e7fe5617507dee222acbe51fe063d",
        "url" => "https://example.com/2017/06/01/an-article-permalink"
      },
      "user" => %{
        "id" => "5495a6b973ce421e8f76d15f362ced41"
      }
    }

    @hivent.Emitter.Cache.clear

    on_exit fn -> @hivent.Emitter.Cache.clear end

    [payload: payload]
  end

  test "when an event is received, it publishes a \"scraper:article:scraped\" event with the augmented article", %{payload: payload} do
    Hivent.emit("listen:article:saved", payload, %{version: 1})

    wait_until 5_000, fn ->
      event = @hivent.Emitter.Cache.last

      assert event
      assert event.meta.name == "scraper:article:scraped"
      assert event.payload.article.id == payload["article"]["id"]
      assert event.payload.article.url
      assert event.payload.article.title
      assert event.payload.article.text
      assert event.payload.article.html
      assert event.payload.article.authors
      assert event.payload.article.source
      assert event.payload.article.images
    end
  end
end
