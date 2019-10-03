defmodule WhtWeb.RequestBucketController do
  use WhtWeb, :controller

  def create(conn, _) do
    {id, _} = Wht.WebhookRepository.create_webhook_bucket()
    redirect(conn, to: Routes.request_bucket_path(conn, :show, id))
  end

  def show(conn, %{"id" => id}) do
    case Wht.WebhookRepository.get_bucket_state(id) do
      {:error, :not_found} -> render_not_found(conn)
      {id, requests} -> render(conn, "show.html", requests: requests)
    end
  end
end
