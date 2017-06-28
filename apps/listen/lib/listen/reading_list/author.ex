defmodule Listen.ReadingList.Author do
  use Ecto.Schema
  import Ecto.Changeset, warn: false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "authors" do
    field :name, :string

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
