defmodule Listen.ReadingList.Article do
  use Ecto.Schema

  import Ecto.Query

  alias Listen.Accounts.User
  alias Listen.ReadingList.{Author, AuthorArticle, Image, Source, UserArticle}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "articles" do
    field :url, :string
    field :title, :string
    field :text, :string
    field :html, :string

    many_to_many :users, User, join_through: UserArticle, on_delete: :delete_all, on_replace: :delete
    many_to_many :authors, Author, join_through: AuthorArticle, on_delete: :delete_all, on_replace: :delete
    belongs_to :source, Source
    has_many :images, Image

    timestamps()
  end

  # @doc """
  # Queries articles with authors
  # """
  def with_authors(query) do
    from q in query, preload: [:authors]
  end

  # @doc """
  # Queries articles with images
  # """
  def with_images(query) do
    from q in query, preload: [:images]
  end

  # @doc """
  # Queries articles with images
  # """
  def with_source(query) do
    from q in query, preload: [:source]
  end

  # @doc """
  # Queries articles with images
  # """
  def with_everything(query) do
    with_authors(query) |> with_images |> with_source
  end

  # @doc """
  # Queries articles belonging to a user
  # """
  def by_user(query, user) do
    from a in query,
      join: u in assoc(a, :users),
      where: u.id == ^user.id
  end

  # @doc """
  # Builds a changeset based on the `struct` and `params`.
  # """
  # def changeset(struct, params \\ %{}) do
  #   struct
  #   |> cast(params, [:url])
  #   |> validate_required([:url])
  # end
end
