defmodule Listen.Web.LayoutView do
  use Listen.Web, :view

  def identity_path(_conn, :login) do
    Application.fetch_env!(:listen, :identity_base_path)
    |> Path.join("login")
  end

  def identity_path(_conn, :register) do
    Application.fetch_env!(:listen, :identity_base_path)
    |> Path.join("register")
  end
end