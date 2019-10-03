defmodule WebhookRepositoryTest do
  use ExUnit.Case
  alias Wht.WebhookRepository, as: Repo
  alias Wht.RequestLog

  describe "create_webhook_bucket/0" do
    test "creates an empty bucket" do
      {_, requests} = Repo.create_webhook_bucket()
      assert length(requests) == 0
    end
  end

  describe "remove_webhook_bucket/1" do
    setup :create_bucket

    test "removes the bucket", %{bucket_id: bucket_id} do
      assert Repo.remove_webhook_bucket(bucket_id) == :ok
      assert Repo.get_bucket_state(bucket_id) == {:error, :not_found}
    end
  end

  describe "get_bucket_state/1 for existing bucket" do
    setup :create_bucket

    test "returns bucket state", %{bucket_id: bucket_id} do
      assert Repo.get_bucket_state(bucket_id) == {bucket_id, []}
    end
  end

  describe "get_bucket_state/1 for non existing bucket" do
    test "returns error tuple" do
      assert Repo.get_bucket_state("non_existing_id") == {:error, :not_found}
    end
  end

  describe "add_request_log/2" do
    test "request log is added to bucket state" do
      {bucket_id, _} = Repo.create_webhook_bucket()
      Repo.add_request_log(bucket_id, Phoenix.ConnTest.build_conn())
      {^bucket_id, [request_log]} = Repo.get_bucket_state(bucket_id)
      assert %RequestLog{} = request_log
    end
  end

  defp create_bucket(_context) do
    {bucket_id, _} = Repo.create_webhook_bucket()
    %{bucket_id: bucket_id}
  end
end
