defmodule Listen.Repo.Migrations.AddScrapedArticleAttributes do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :title, :string
      add :text, :text
      add :html, :text
    end
  end
end
