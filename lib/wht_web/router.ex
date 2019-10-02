defmodule WhtWeb.Router do
  use WhtWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WhtWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/request_buckets", RequestBucketController, only: [:create, :show]
  end

  scope "/webhooks", WhtWeb do
    match :*, "/:id", WebhookController, :track
  end

  # Other scopes may use custom stacks.
  # scope "/api", WhtWeb do
  #   pipe_through :api
  # end
end
