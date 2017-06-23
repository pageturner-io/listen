defmodule Listen.Repo.Migrations.UniqueArticleUrl do
  use Ecto.Migration

  def change do
    create unique_index(:articles, [:url])
  end
end
