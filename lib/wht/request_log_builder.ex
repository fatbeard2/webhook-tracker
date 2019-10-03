defmodule Wht.RequestLogBuilder do
  @moduledoc """
    This module is used to build `Wht.RequestLog` structs
  """

  @doc """
    Builds `Wht.RequestLog` from `Plug.Conn`

    Captures some fields from `Plug.Conn` struct
    and builds a `Wht.RequestLog` struct that will be later stored in a bucket.
    There is too much information in `Plug.Conn` so we only capture fields we need

    Examples:

      iex> conn = %Plug.Conn{ resp_headers: [{"x-request-id", "request_id"}], remote_ip: {127,0,0,1}, method: "POST", host: "localhost", req_headers: [{"Accept", "*/*"}], query_params: %{q: "term"}, body_params: %{body: "present"} }
      iex> Wht.RequestLogBuilder.build(conn)
      %Wht.RequestLog{
        body_params: %{body: "present"},
        headers: [{"Accept", "*/*"}],
        host: "localhost",
        method: "POST",
        query_params: %{q: "term"},
        remote_ip: "127.0.0.1",
        request_id: "request_id"
      }
  """

  @spec build(Plug.Conn.t()) :: Wht.RequestLog.t()
  def build(%Plug.Conn{} = conn) do
    %Wht.RequestLog{
      method: conn.method,
      request_id: Plug.Conn.get_resp_header(conn, "x-request-id") |> Enum.at(0),
      query_params: conn.query_params,
      body_params: conn.body_params,
      headers: conn.req_headers,
      remote_ip: conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
      host: conn.host
    }
  end
end
