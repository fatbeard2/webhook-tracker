defmodule Wht.WebhookBucket do
  use Agent, restart: :temporary

  def start_link(id) do
    Agent.start_link(fn -> { id, [] } end)
  end

  def get_bucket_state(bucket) do
    Agent.get(bucket, &(&1))
  end

  def add_request(bucket, request) do
    Agent.cast(bucket, fn { id, requests } -> { id, [request | requests] } end)
  end
end
