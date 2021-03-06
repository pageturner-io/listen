defmodule Listen.ReadingList do
  @moduledoc """
  The boundary for the Reading List system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Listen.Repo
  alias Listen.ReadingList.{Article, UserArticle}
  alias Listen.Accounts.{User}

  @hivent Application.get_env(:listen, :hivent)

  def list_articles(user) do
    Article
    |> Article.scraped
    |> Article.with_everything
    |> Article.by_user(user)
    |> Repo.all
  end

  def get_article!(article_id, _user \\ nil) do
    Article
    |> Article.with_everything
    |> Repo.get!(article_id)
  end

  def get_article(article_id, _user \\ nil) do
    Article
    |> Article.with_everything
    |> Repo.get(article_id)
  end

  def create_article(attrs = %{}, user) do
    %Article{}
    |> article_changeset(attrs)
    |> create_article_with_user(user)
    |> publish_article_saved_event
  end

  def update_article(article = %Article{}, attrs \\ %{}) do
    change_article(article, attrs)
    |> Repo.update
  end

  def remove_article(article, user) do
    from(entry in UserArticle, where: entry.user_id == ^user.id and entry.article_id == ^article.id)
    |> Repo.delete_all

    {:ok, article}
  end

  def change_article(%Article{} = article \\ %Article{}, changes \\ %{}) do
    article_changeset(article, changes)
  end

  defp article_changeset(%Article{} = article, attrs) do
    article
    |> cast(attrs, [:url, :title, :text, :html])
    |> validate_required([:url])
    |> cast_assoc(:source)
    |> cast_assoc(:authors)
    |> cast_assoc(:images)
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

  defp publish_article_saved_event({:error, error}), do: {:error, error}
  defp publish_article_saved_event({:ok, %Article{} = article}) do
    [%User{} = user | _] = article.users

    @hivent.emit("listen:article:saved", %{
      user: %{
        id: user.id,
      },
      article: %{
        id: article.id,
        url: article.url
      }
    }, %{version: 1, key: user.id |> :erlang.crc32})

    {:ok, article}
  end

end
