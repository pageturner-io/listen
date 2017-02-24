defmodule Web.Factory do
  use ExMachina.Ecto, repo: Web.Repo

  alias Web.{User}

  def user_factory do
    %User{
      id: sequence("") |> String.to_integer,
      name: "Bob Belcher",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end
end
