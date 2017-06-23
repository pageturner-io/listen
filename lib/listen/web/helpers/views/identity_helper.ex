defmodule Listen.Web.Helpers.Views.Identity do
  def identity_path(_conn, :login) do
    Listen.Config.get(:listen, :identity_base_path)
    |> Path.join("login")
  end

  def identity_path(_conn, :register) do
    Listen.Config.get(:listen, :identity_base_path)
    |> Path.join("register")
  end
end
