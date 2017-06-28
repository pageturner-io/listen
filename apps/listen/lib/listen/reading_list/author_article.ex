defmodule Listen.ReadingList.AuthorArticle do
  use Ecto.Schema

  alias Listen.ReadingList.{Author, Article}

  @primary_key false
  @foreign_key_type :binary_id
  schema "authors_articles" do
    belongs_to :author, Author
    belongs_to :article, Article

    timestamps()
  end
end
