defmodule Listen.Web.PageController do
  use Listen.Web, :controller
  use Guardian.Phoenix.Controller

  def index(conn, _params, current_user, _claims) when is_nil(current_user) do
    render conn, "index.html"
  end
  def index(conn, _params, _current_user, _claims) do
    redirect conn, to: "/read"
  end
end
