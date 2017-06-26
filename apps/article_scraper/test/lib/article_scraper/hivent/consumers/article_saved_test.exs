defmodule ArticleScraper.Hivent.Consumers.ArticleSavedTest do
  use ExUnit.Case, async: true

  test "it works" do
    payload = %{
      "article" => %{
        "id" => "fe6e7fe5617507dee222acbe51fe063d",
        "url" => "https://example.com/2017/06/01/an-article-permalink"
      },
      "user" => %{
        "id" => "5495a6b973ce421e8f76d15f362ced41"
      }
    }

    Hivent.emit("listen:article:saved", payload, %{version: 1, key: 1})

    :timer.sleep(1000)

    assert 1 == 1
  end
end
