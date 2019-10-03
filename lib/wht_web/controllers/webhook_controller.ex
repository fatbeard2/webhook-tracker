defmodule WhtWeb.WebhookController do
  require Logger
  import Plug.Conn
  use WhtWeb, :controller

  def track(conn, %{"id" => id}) do
    case Wht.WebhookRepository.add_request_log(id, conn) do
      :ok ->
        send_resp(conn, :ok, "")

      {:error, :not_found} ->
        send_resp(conn, :not_found, "")
    end
  end
end
