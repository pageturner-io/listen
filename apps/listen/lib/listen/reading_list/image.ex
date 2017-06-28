defmodule Listen.ReadingList.Image do
  use Ecto.Schema

  import Ecto.Changeset, warn: false

  alias Listen.ReadingList.Article

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "images" do
    field :url, :string

    belongs_to :article, Article

    timestamps()
  end

  # @doc """
  # Builds a changeset based on the `struct` and `params`.
  # """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url])
    |> validate_required([:url])
  end
end
