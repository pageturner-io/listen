defmodule Listen.Web.ErrorController do
  use Listen.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You must be signed in to access this page.")
    |> redirect(to: page_path(conn, :index))
  end
end
