defmodule Wht.WebhookRepository do
  def create_webhook_bucket do
    UUID.uuid4()
    |> build_name_tuple()
    |> spawn_bucket_process()
    |> get_bucket_state()
  end

  def get_bucket_state(id) do
    get_bucket_pid(id) |> Wht.WebhookBucket.get_bucket_state
  end

  @spec add_request_log(String.t, Plug.Conn.t) :: atom
  def add_request_log(id, %Plug.Conn{} = conn) do
    request_log = Wht.RequestLogBuilder.build(conn)
    get_bucket_pid(id)
    |> Wht.WebhookBucket.add_request(request_log)
  end

  defp get_bucket_pid(id) do
    case Registry.lookup(Wht.WebhookRegistry, id) do
      [{ pid, _ }] -> pid
      _ -> nil
    end
  end

  defp build_name_tuple(id) do
    { :via, Registry, { Wht.WebhookRegistry, id }}
  end

  defp spawn_bucket_process(name_tuple = { :via, _, { _, id } }) do
    { :ok, _ } = DynamicSupervisor.start_child(Wht.WebhookSupervisor, bucket_child_spec(id, name_tuple))
    id
  end

  defp bucket_child_spec(id, name_tuple) do
    Wht.WebhookBucket.child_spec({ id, name_tuple })
  end
end
