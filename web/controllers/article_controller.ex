defmodule Listen.ArticleController do
  use Listen.Web, :controller
  use Guardian.Phoenix.Controller

  alias Listen.Article

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
    |> Ecto.Changeset.put_assoc(:users, [current_user])

    case Repo.insert(changeset, on_conflict: [set: [url: article_params["url"]]], conflict_target: :url) do
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

  def edit(conn, %{"id" => id}, _current_user, _claims) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}, _current_user, _claims) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claims) do
    article = Repo.get!(Article, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: article_path(conn, :index))
  end
end
