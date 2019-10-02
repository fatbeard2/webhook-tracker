defmodule WhtWeb.WebhookController do
  require Logger
  import Plug.Conn
  use WhtWeb, :controller

  def track(conn, %{ "id" => id }) do
    Wht.WebhookRepository.add_request_log(id, conn)
    send_resp(conn, :ok, "")
  end
end
