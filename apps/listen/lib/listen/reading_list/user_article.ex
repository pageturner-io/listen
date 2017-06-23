defmodule Listen.ReadingList.UserArticle do
  use Ecto.Schema

  alias Listen.ReadingList.Article
  alias Listen.Accounts.User

  @primary_key false
  @foreign_key_type :binary_id
  schema "users_articles" do
    belongs_to :user, User
    belongs_to :article, Article

    timestamps()
  end

  # def changeset(struct, params \\ %{}) do
  #   struct
  #   |> Ecto.Changeset.cast(params, [:user_id, :article_id])
  #   |> Ecto.Changeset.validate_required([:user_id, :article_id])
  # end
end
