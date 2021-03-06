defmodule Listen.ReadingListControllerTest do
  use Listen.Web.ConnCase

  import Listen.Factory
  import Listen.Web.Gettext

  alias Listen.ReadingList
  alias Listen.ReadingList.Article

  @valid_attrs %{
    url: "https://example.com",
    title: "A title",
    text: "Some text",
    html: "<p>Some text</p>",
    authors: [
      %{name: "An author"}
    ],
    source: %{name: "The Source"},
    images: [
      %{url: "https://example.com/img.jpg"}
    ],
  }
  @invalid_attrs %{}

  def fixture(:article, user, attrs \\ @valid_attrs) do
    {:ok, article} = ReadingList.create_article(attrs, user)
    article
  end

  describe "without a logged in user" do

    test "index redirects to root with a flash error", %{conn: conn} do
      conn = get conn, reading_list_path(conn, :index)

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
      article = fixture(:article, user)
      fixture(:article, other_user)

      other_article = fixture(:article, other_user, %{@valid_attrs | title: "Another title", url: "https://foo.bar"})

      conn = get conn, reading_list_path(conn, :index)

      assert html_response(conn, 200) =~ article.title
      assert html_response(conn, 200) =~ reading_list_path(conn, :show, article)
      refute html_response(conn, 200) =~ other_article.title
    end

    test "renders form for new articles", %{conn: conn} do
      conn = get conn, reading_list_path(conn, :new)

      assert html_response(conn, 200) =~ gettext("Save new article")
    end

    test "creates article when data is valid", %{conn: conn, user: user} do
      old_count = Repo.aggregate(Article, :count, :id)

      conn = post conn, reading_list_path(conn, :create), article: @valid_attrs

      assert redirected_to(conn) == reading_list_path(conn, :index)

      assert Repo.aggregate(Article, :count, :id) == old_count + 1

      users = Repo.one(from a in Article, order_by: [desc: a.inserted_at], limit: 1)
      |> Repo.preload(:users)
      |> Map.get(:users)

      assert Enum.member?(users, user)
    end

    test "does not create a new article if one with the same url already exists", %{conn: conn, other_user: other_user} do
      fixture(:article, other_user)
      previous_count = Repo.aggregate(Article, :count, :id)

      post conn, reading_list_path(conn, :create), article: @valid_attrs

      assert Repo.aggregate(Article, :count, :id) == previous_count
    end

    test "does not create article and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, reading_list_path(conn, :create), article: @invalid_attrs

      assert html_response(conn, 200) =~ gettext("Save new article")
      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end

    test "shows chosen article", %{conn: conn, user: user} do
      article = fixture(:article, user)
      conn = get conn, reading_list_path(conn, :show, article)

      assert html_response(conn, 200) =~ article.title
      assert html_response(conn, 200) =~ article.html
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, reading_list_path(conn, :show, "0e31998f-503f-4218-a801-c8bb7ff9498b")
      end
    end

    test "deletes the association between user and article, but not the article itself", %{conn: conn, user: user} do
      article = fixture(:article, user)

      conn = delete conn, reading_list_path(conn, :delete, article)
      assert redirected_to(conn) == reading_list_path(conn, :index)

      updated_article = ReadingList.get_article!(article.id, user) |> Repo.preload(:users)

      assert updated_article
      refute Enum.member?(updated_article.users, user)
    end

  end
end
