defmodule Listen.Article do
  use Listen.Web, :model

  schema "articles" do
    field :url, :string

    many_to_many :users, Listen.User, join_through: Listen.UserArticle, on_delete: :delete_all, on_replace: :delete

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url])
    |> validate_required([:url])
  end
end
