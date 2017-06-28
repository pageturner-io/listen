defmodule Listen.Factory do
  use ExMachina.Ecto, repo: Listen.Repo

  use Listen.ArticleFactory
  use Listen.AuthorFactory
  use Listen.ImageFactory
  use Listen.SourceFactory
  use Listen.UserFactory
end
