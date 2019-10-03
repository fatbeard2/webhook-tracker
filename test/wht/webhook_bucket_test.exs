defmodule WebhookBucketTest do
  use ExUnit.Case
  alias Wht.WebhookBucket

  @bucket_id "generated_uuid"
  @bucket_name :webhook_bucket

  setup do
    start_supervised({WebhookBucket, {@bucket_id, @bucket_name}})
    :ok
  end

  describe "get_bucket_state/1 for existing bucket" do
    setup :existing_bucket_name

    test "returns bucket state", %{bucket_name: bucket_name} do
      assert WebhookBucket.get_bucket_state(bucket_name) == {@bucket_id, []}
    end
  end

  describe "get_bucket_state/1 for non existing bucket" do
    setup :non_existing_bucket_name

    test "exits with :noproc reason", %{bucket_name: bucket_name} do
      {reason, _} = catch_exit(WebhookBucket.get_bucket_state(bucket_name))
      assert reason == :noproc
    end
  end

  describe "add_request/2 for existing bucket" do
    setup :existing_bucket_name

    test "adds request entry to the bucket", %{bucket_name: bucket_name} do
      assert WebhookBucket.add_request(bucket_name, "new_request") == :ok
      assert WebhookBucket.get_bucket_state(bucket_name) == {@bucket_id, ["new_request"]}
    end
  end

  describe "add_requests/2 for non existing bucket" do
    setup :non_existing_bucket_name

    test "returns :ok for non existing buckets", %{bucket_name: bucket_name} do
      assert WebhookBucket.add_request(bucket_name, "new_request") == :ok
    end
  end

  defp existing_bucket_name(_context) do
    [bucket_name: @bucket_name]
  end

  defp non_existing_bucket_name(_context) do
    [bucket_name: :non_existing_bucket_name]
  end
end
