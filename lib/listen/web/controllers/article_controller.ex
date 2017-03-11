defmodule Listen.Web.ArticleController do
  use Listen.Web, :controller
  use Guardian.Phoenix.Controller

  alias Listen.{Article, UserArticle}

  def index(conn, _params, current_user, _claims) do
    articles = Repo.preload(current_user, :articles).articles

    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params, _current_user, _claims) do
    changeset = Article.changeset(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}, current_user, _claims) do
    changeset = Article.changeset(%Article{}, article_params)

    case create_article_with_user(changeset, current_user) do
      {:ok, _article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: article_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claims) do
    article = Repo.get!(Article, id)
    render(conn, "show.html", article: article)
  end


  def delete(conn, %{"id" => article_id}, current_user, _claims) do
    from(entry in UserArticle, where: entry.user_id == ^current_user.id and entry.article_id == ^article_id)
    |> Repo.delete_all

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: article_path(conn, :index))
  end

  defp create_article_with_user(changeset, user) do
    if changeset.valid? do
      url = Ecto.Changeset.get_field(changeset, :url)

      case Repo.get_by(Article, url: url) do
        nil -> Repo.insert!(changeset)
        article -> article
      end
      |> Repo.preload(:users)
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:users, [user])
      |> Repo.update
    else
      {:error, %{changeset | action: :insert}}
    end
  end
end
