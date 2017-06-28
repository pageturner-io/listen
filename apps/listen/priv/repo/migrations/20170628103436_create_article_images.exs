defmodule Listen.Repo.Migrations.CreateArticleImages do
  use Ecto.Migration

  def change do
    create table(:article_images, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :article_id, references(:articles, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end
  end
end
