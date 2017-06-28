defmodule Listen.Repo.Migrations.CreateAuthor do
  use Ecto.Migration

  def change do
    create table(:authors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps()
    end

    create table(:authors_articles, primary_key: false) do
      add :author_id, references(:authors, type: :binary_id, on_delete: :delete_all)
      add :article_id, references(:articles, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end
  end
end
