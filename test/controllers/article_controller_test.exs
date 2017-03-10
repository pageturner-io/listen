defmodule Listen.ArticleControllerTest do
  use Listen.ConnCase

  import Listen.Factory

  alias Listen.Article
  @valid_attrs %{url: "https://example.com"}
  @invalid_attrs %{}

  describe "without a logged in user" do

    test "/articles redirects to root with a flash error", %{conn: conn} do
      conn = get(conn, "/articles")

      assert redirected_to(conn) =~ page_path(conn, :index)
      assert get_flash(conn, :error) == "You must be signed in to access this page."
    end

  end

  describe "with a logged in user" do

    setup %{conn: conn} do
      user = insert(:user)
      other_user = insert(:user)

      {:ok, %{
          user: user,
          other_user: other_user,
          conn: guardian_login(conn, user)
        }
      }
    end

    test "lists all articles submitted by user on index", %{conn: conn, user: user, other_user: other_user} do
      article = Repo.insert!(%Article{url: "https://example.com"})
      other_article = Repo.insert!(%Article{url: "https://foobar.com"})

      Repo.preload(user, :articles) |> Ecto.Changeset.change() |> Ecto.Changeset.put_assoc(:articles, [article]) |> Repo.update!
      Repo.preload(other_user, :articles) |> Ecto.Changeset.change() |> Ecto.Changeset.put_assoc(:articles, [other_article]) |> Repo.update!

      conn = get conn, article_path(conn, :index)

      assert html_response(conn, 200) =~ article.url
      refute html_response(conn, 200) =~ other_article.url
    end

    test "renders form for new articles", %{conn: conn} do
      conn = get conn, article_path(conn, :new)

      assert html_response(conn, 200) =~ "New article"
    end

    test "creates article and redirects when data is valid", %{conn: conn, user: user} do
      conn = post conn, article_path(conn, :create), article: @valid_attrs

      article = Repo.get_by(Article, @valid_attrs)
      user_article = Repo.preload(user, :articles).articles
      |> Enum.find(fn(a) -> a.url == @valid_attrs.url end)

      assert redirected_to(conn) == article_path(conn, :index)
      assert article
      assert user_article == article
    end

    test "does not create article and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, article_path(conn, :create), article: @invalid_attrs

      assert html_response(conn, 200) =~ "New article"
    end

    test "shows chosen article", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = get conn, article_path(conn, :show, article)

      assert html_response(conn, 200) =~ "Show article"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, article_path(conn, :show, "0e31998f-503f-4218-a801-c8bb7ff9498b")
      end
    end

    test "renders form for editing chosen article", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = get conn, article_path(conn, :edit, article)
      assert html_response(conn, 200) =~ "Edit article"
    end

    test "updates chosen article and redirects when data is valid", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = put conn, article_path(conn, :update, article), article: @valid_attrs
      assert redirected_to(conn) == article_path(conn, :show, article)
      assert Repo.get_by(Article, @valid_attrs)
    end

    test "does not update chosen article and renders errors when data is invalid", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = put conn, article_path(conn, :update, article), article: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit article"
    end

    test "deletes chosen article", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = delete conn, article_path(conn, :delete, article)
      assert redirected_to(conn) == article_path(conn, :index)
      refute Repo.get(Article, article.id)
    end

  end
end
