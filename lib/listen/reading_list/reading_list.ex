defmodule Listen.ReadingList do
  @moduledoc """
  The boundary for the Reading List system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Listen.Repo
  alias Listen.ReadingList.{Article, UserArticle}

  def list_articles(user) do
    Repo.preload(user, :articles).articles
  end

  def get_article!(article_id, _user), do: Repo.get!(Article, article_id)
  def get_article(article_id, _user), do: Repo.get(Article, article_id)

  def create_article(attrs = %{}, user) do
    %Article{}
    |> article_changeset(attrs)
    |> create_article_with_user(user)
  end

  def remove_article(article, user) do
    from(entry in UserArticle, where: entry.user_id == ^user.id and entry.article_id == ^article.id)
    |> Repo.delete_all

    {:ok, article}
  end

  def change_article(%Article{} = article \\ %Article{}) do
    article_changeset(article, %{})
  end

  defp article_changeset(%Article{} = article, attrs) do
    article
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end

  defp create_article_with_user(changeset, user) do
    if changeset.valid? do
      url = Ecto.Changeset.get_field(changeset, :url)

      changeset = case Repo.get_by(Article, url: url) do
        nil -> Repo.insert!(changeset)
        article -> article
      end
      |> Repo.preload(:users)
      |> Ecto.Changeset.change()

      users = Map.get(changeset, :data) |> Map.get(:users)

      Ecto.Changeset.put_assoc(changeset, :users, [user | users]) |> Repo.update
    else
      {:error, %{changeset | action: :insert}}
    end
  end


end
