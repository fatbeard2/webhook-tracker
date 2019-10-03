defmodule WhtWeb.Controller.Helpers do
  import Plug.Conn
  import Phoenix.Controller

  def render_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(WhtWeb.ErrorView)
    |> render("404.html")
  end
end
