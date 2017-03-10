defmodule Listen.User do
  use Listen.Web, :model

  @primary_key {:id, :binary_id, []}
  schema "users" do
    field :name, :string
    field :email, :string

    many_to_many :articles, Listen.Article, join_through: Listen.UserArticle

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :name, :email])
  end
end
