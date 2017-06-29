defmodule Listen.Web.Helpers.Views.Identity do
  def identity_path(conn, :login) do
    Listen.Config.get(:listen, :identity_base_path)
    |> Path.join("login")
    |> URI.parse
    |> URI.merge(query(conn))
    |> URI.to_string
  end

  def identity_path(conn, :register) do
    Listen.Config.get(:listen, :identity_base_path)
    |> Path.join("register")
    |> URI.parse
    |> URI.merge(query(conn))
    |> URI.to_string
  end

  defp query(conn) do
    return_url = Listen.Web.Router.Helpers.url(conn) <> conn.request_path

    %URI{
      query: URI.encode_query(%{return_url: return_url})
    }
  end
end
