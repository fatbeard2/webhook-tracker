defmodule WhtWeb.PageController do
  use WhtWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
