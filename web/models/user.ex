defmodule Listen.User do
  use Listen.Web, :model

  @primary_key {:id, :binary_id, []}
  schema "users" do
    field :name, :string
    field :email, :string

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
