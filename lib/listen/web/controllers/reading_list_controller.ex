defmodule Listen.Web.ReadingListController do
  use Listen.Web, :controller
  use Guardian.Phoenix.Controller

  alias Listen.ReadingList

  def index(conn, _params, current_user, _claims) do
    articles = ReadingList.list_articles(current_user)

    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params, _current_user, _claims) do
    render(conn, "new.html", changeset: ReadingList.change_article())
  end

  def create(conn, %{"article" => article_params}, current_user, _claims) do
    case ReadingList.create_article(article_params, current_user) do
      {:ok, _article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: reading_list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    article = ReadingList.get_article!(id, current_user)
    render(conn, "show.html", article: article)
  end

  def delete(conn, %{"id" => id}, current_user, _claims) do
    ReadingList.get_article(id, current_user)
    |> ReadingList.remove_article(current_user)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: reading_list_path(conn, :index))
  end
end
