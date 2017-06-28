defmodule Listen.Repo.Migrations.AddScrapedArticleAttributes do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :title, :string
      add :text, :string
      add :html, :string
    end
  end
end
