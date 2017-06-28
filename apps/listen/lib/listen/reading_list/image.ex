defmodule Listen.ReadingList.Image do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "images" do
    field :url, :string

    timestamps()
  end
end
