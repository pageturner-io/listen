defmodule Listen.Repo.Migrations.CreateUserArticle do
  use Ecto.Migration

  def change do
    create table(:user_articles, primary_key: false) do
      add :user_id, references(:users, type: :binary_id)
      add :article_id, references(:articles, type: :binary_id)

      timestamps()
    end

  end
end
