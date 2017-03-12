defmodule Listen.Accounts.User do
  use Ecto.Schema

  @primary_key {:id, :binary_id, []}
  schema "users" do
    field :name, :string
    field :email, :string

    many_to_many :articles, Listen.ReadingList.Article, join_through: Listen.ReadingList.UserArticle

    timestamps()
  end
end
