defmodule Listen.Factory do
  use ExMachina.Ecto, repo: Listen.Repo

  use Listen.ArticleFactory
  use Listen.UserFactory
end
