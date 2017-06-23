defmodule Listen.PageControllerTest do
  use Listen.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Listen"
  end
end
