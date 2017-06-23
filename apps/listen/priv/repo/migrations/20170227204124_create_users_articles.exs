defmodule Listen.Repo.Migrations.CreateUsersArticles do
  use Ecto.Migration

  def change do
    create table(:users_articles, primary_key: false) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :article_id, references(:articles, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

  end
end
