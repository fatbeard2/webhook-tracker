defmodule Wht.RequestLog do
  defstruct [
    :method,
    :request_id,
    :query_params,
    :body_params,
    :headers,
    :remote_ip,
    :host
  ]

  @type t() :: %__MODULE__{
    method: String.t,
    request_id: String.t,
    query_params: map,
    body_params: map,
    headers: list(tuple),
    remote_ip: String.t,
    host: String.t
  }
end
