defmodule Wht.WebhookRepository do
  def create_webhook_bucket do
    UUID.uuid4()
    |> build_name_tuple()
    |> spawn_bucket_process()
    |> get_bucket_state()
  end

  def get_bucket_state({ :ok, bucket_pid }) do
    Wht.WebhookBucket.get_bucket_state(bucket_pid)
  end

  def get_bucket_state(id) do
    get_bucket_state({ :ok, get_bucket_pid(id) })
  end

  def get_bucket_pid(id) do
    case Registry.lookup(Wht.WebhookRegistry, id) do
      [{ pid, _ }] -> pid
      _ -> nil
    end
  end

  defp build_name_tuple(id) do
    { :via, Registry, { Wht.WebhookRegistry, id }}
  end

  defp spawn_bucket_process(name_tuple) do
    DynamicSupervisor.start_child(Wht.WebhookSupervisor, bucket_child_spec(name_tuple))
  end

  defp bucket_child_spec(name_tuple = { _, _, { _, id }}) do
    Wht.WebhookBucket.child_spec(id)
    |> Map.put(:name, name_tuple)
  end
end
