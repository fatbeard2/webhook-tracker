defmodule Wht.RequestLog do
  @moduledoc """
    This module defines `Wht.RequestLog` that will be stored in webhook buckets.
    Struct contains information about request params, body, headers and some additional
    information like request id and time of request
  """

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
          method: String.t(),
          request_id: String.t(),
          query_params: map,
          body_params: map,
          headers: list(tuple),
          remote_ip: String.t(),
          host: String.t()
        }
end
