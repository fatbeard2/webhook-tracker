defmodule Wht.WebhookRepository do
  @moduledoc """
    This module provides functions to access/write to webhook buckets as well as create them
  """

  @doc """
    Generates ID for the bucket, spawns a supervised process and returns bucket state

    Further access to the bucket is done by its id. In order to find a process by generated id
    we're using `Registry` module. `build_name_tuple` is used to generate a name by bucket id.
    All webhook buckets are supervised by `DynamicSupervisor` with `Wht.WebhookSupervisor` name
  """

  @typedoc "Error tuple indicating that bucket does not exist"
  @type not_found_tuple :: {:error, :not_found}

  @spec create_webhook_bucket() :: Wht.WebhookBucket.state()
  def create_webhook_bucket do
    UUID.uuid4()
    |> build_name_tuple()
    |> spawn_bucket_process()
    |> get_bucket_state()
  end

  @doc """
    Removes webhook bucket by id
  """
  @spec remove_webhook_bucket(String.t()) :: :ok | not_found_tuple()
  def remove_webhook_bucket(id) do
    DynamicSupervisor.terminate_child(Wht.WebhookSupervisor, get_bucket_pid(id))
  end

  @doc """
    Returns the bucket state by provided id
  """
  @spec get_bucket_state(String.t()) :: Wht.WebhookBucket.state() | not_found_tuple()
  def get_bucket_state(id) do
    bucket_pid = get_bucket_pid(id)

    if bucket_pid do
      Wht.WebhookBucket.get_bucket_state(bucket_pid)
    else
      build_not_found_tuple()
    end
  end

  @doc """
    Adds request log to the bucket with provided id
  """
  @spec add_request_log(String.t(), Plug.Conn.t()) :: :ok | not_found_tuple()
  def add_request_log(id, %Plug.Conn{} = conn) do
    bucket_pid = get_bucket_pid(id)

    if bucket_pid do
      request_log = Wht.RequestLogBuilder.build(conn)
      Wht.WebhookBucket.add_request(bucket_pid, request_log)
    else
      build_not_found_tuple()
    end
  end

  @doc """
    Builds a name tuple for process by provided id

    Process registration is done using `Registry`. This module provides a storage that
    can map generated webhook id with custom process. `WebhookRegistry` is started as a
    supervised process in `application.ex`.

    ```
      {Registry, keys: :unique, name: Wht.WebhookRegistry},
    ```

    Examples:

      iex> Wht.WebhookRepository.build_name_tuple("some_uuid")
      {:via, Registry, {Wht.WebhookRegistry, "some_uuid"}}
  """
  @spec build_name_tuple(String.t()) :: tuple()
  def build_name_tuple(id) do
    {:via, Registry, {Wht.WebhookRegistry, id}}
  end

  defp build_not_found_tuple do
    {:error, :not_found}
  end

  defp get_bucket_pid(id) do
    build_name_tuple(id) |> GenServer.whereis()
  end

  defp spawn_bucket_process(name_tuple = {:via, _, {_, id}}) do
    {:ok, _} =
      DynamicSupervisor.start_child(Wht.WebhookSupervisor, bucket_child_spec(id, name_tuple))

    id
  end

  defp bucket_child_spec(id, name_tuple) do
    Wht.WebhookBucket.child_spec({id, name_tuple})
  end
end
