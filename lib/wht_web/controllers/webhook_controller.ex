defmodule WhtWeb.WebhookController do
  use WhtWeb, :controller

  def create(conn, _) do
    { id, _ } = Wht.WebhookRepository.create_webhook_bucket
    redirect(conn, to: Routes.webhook_path(conn, :show, id))
  end

  def show(conn, %{ "id" => id }) do

  end
end
