defmodule Listen.ReadingList.Article do
  use Ecto.Schema

  alias Listen.Accounts.User
  alias Listen.ReadingList.UserArticle

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "articles" do
    field :url, :string

    many_to_many :users, User, join_through: UserArticle, on_delete: :delete_all, on_replace: :delete

    timestamps()
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