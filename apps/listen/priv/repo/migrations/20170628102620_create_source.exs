defmodule Listen.Repo.Migrations.CreateSource do
  use Ecto.Migration

  def change do
    create table(:sources, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps()
    end

    alter table(:articles) do
      add :source_id, references(:articles, type: :binary_id, on_delete: :nothing)
    end
  end
end
