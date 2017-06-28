defmodule Listen.ReadingList.Source do
  use Ecto.Schema

  import Ecto.Changeset, warn: false

  alias Listen.ReadingList.Article

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sources" do
    field :name, :string

    has_many :articles, Article

    timestamps()
  end

  # @doc """
  # Builds a changeset based on the `struct` and `params`.
  # """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
