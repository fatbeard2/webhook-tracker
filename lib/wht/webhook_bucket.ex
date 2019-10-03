defmodule Wht.WebhookBucket do
  @moduledoc """
    This module is spawned as an Agent that stores a list of requests for a webhook
    Webhook is defined by its id(uuid4). Name of the process is generated using `Registry` module by `Wht.WebhookRepository`
    so that we can find bucket process by webhook id. Id is not used as the name of the process
    because we'd be forced to covert uuid to atom and it will lead to hitting the atom limit eventually.
  """
  use Agent, restart: :temporary

  @typedoc "Internal state of the bucket representation"
  @type state :: {String.t(), [%Wht.RequestLog{}]} | nil

  @doc """
    Spawns a webhook bucket process to store incoming requests
  """
  @spec start_link({String.t(), Agent.name()}) :: Agent.on_start()
  def start_link({id, name}) do
    Agent.start_link(fn -> {id, []} end, name: name)
  end

  @doc """
    Returns bucket state
  """
  @spec get_bucket_state(Agent.name()) :: state
  def get_bucket_state(bucket) do
    Agent.get(bucket, & &1)
  end

  @doc """
    Add a request log to the bucket

    If process with this id is not registered `:ok` is returned anyway.
    This is due to async nature of `Agent.cast`
  """
  @spec add_request(Agent.name(), Wht.RequestLog.t()) :: :ok
  def add_request(bucket, request) do
    Agent.cast(bucket, fn {id, requests} -> {id, [request | requests]} end)
  end
end
