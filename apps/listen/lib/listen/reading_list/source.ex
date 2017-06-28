defmodule Listen.ReadingList.Source do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sources" do
    field :name, :string

    timestamps()
  end
end
