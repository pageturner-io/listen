defmodule Web.ArticleControllerTest do
  use Web.ConnCase

  import Web.Factory

  alias Web.Article
  @valid_attrs %{url: "some content"}
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

      {:ok, %{
          user: user,
          conn: guardian_login(conn, user)
        }
      }
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, article_path(conn, :index)

      assert html_response(conn, 200) =~ "Listing articles"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, article_path(conn, :new)

      assert html_response(conn, 200) =~ "New article"
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post conn, article_path(conn, :create), article: @valid_attrs

      assert redirected_to(conn) == article_path(conn, :index)
      assert Repo.get_by(Article, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, article_path(conn, :create), article: @invalid_attrs

      assert html_response(conn, 200) =~ "New article"
    end

    test "shows chosen resource", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = get conn, article_path(conn, :show, article)

      assert html_response(conn, 200) =~ "Show article"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, article_path(conn, :show, "0e31998f-503f-4218-a801-c8bb7ff9498b")
      end
    end

    test "renders form for editing chosen resource", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = get conn, article_path(conn, :edit, article)
      assert html_response(conn, 200) =~ "Edit article"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = put conn, article_path(conn, :update, article), article: @valid_attrs
      assert redirected_to(conn) == article_path(conn, :show, article)
      assert Repo.get_by(Article, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = put conn, article_path(conn, :update, article), article: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit article"
    end

    test "deletes chosen resource", %{conn: conn} do
      article = Repo.insert! %Article{}
      conn = delete conn, article_path(conn, :delete, article)
      assert redirected_to(conn) == article_path(conn, :index)
      refute Repo.get(Article, article.id)
    end

  end
end
