defmodule WhtWeb.PageControllerTest do
  use WhtWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Webhook tracker"
  end
end
