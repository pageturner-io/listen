defmodule Listen.UserArticle do
  use Listen.Web, :model

  alias Listen.Article
  alias Listen.Accounts.User

  @primary_key false
  schema "users_articles" do
    belongs_to :user, User
    belongs_to :article, Article

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:user_id, :article_id])
    |> Ecto.Changeset.validate_required([:user_id, :article_id])
  end
end
