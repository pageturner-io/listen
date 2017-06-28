defmodule Listen.Repo.Migrations.ChangeArticleImages do
  use Ecto.Migration

  def change do
    rename table(:article_images), to: table(:images)
  end
end
