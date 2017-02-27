defmodule Web.UserArticle do
  use Web.Web, :model

  @primary_key false
  schema "user_articles" do
    belongs_to :user, User
    belongs_to :article, Article

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :article_id])
    |> validate_required([:user_id, :article_id])
  end
end
