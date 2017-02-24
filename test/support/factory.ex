defmodule Web.Factory do
  use ExMachina.Ecto, repo: Web.Repo

  alias Web.{User}

  def user_factory do
    %User{
      id: Ecto.UUID.generate(),
      name: "Bob Belcher",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end
end
