defmodule ElixirDropbox do
  @moduledoc """
  ElixirDropbox is a wrapper for Dropbox API V2
  """
  use HTTPoison.Base
  require Logger
  @type response :: {any}

  @base_url_v1 "https://api.dropboxapi.com/1"
  @base_url "https://content.dropboxapi.com/2"
  @upload_url "https://content.dropboxapi.com/2"
  
  def post_v1(client, url, body \\ "") do
    headers = json_headers()
    post_request(client, "#{@base_url_v1}#{url}", body, headers)
  end
  
  def post(client, url, body \\ "") do
    headers = json_headers()
    post_request(client, "#{@base_url}#{url}", body, headers)
  end

  @spec upload_response(HTTPoison.Response.t) :: response
  def upload_response(%HTTPoison.Response{status_code: 200, body: body}), do: Poison.decode!(body)
  def upload_response(%HTTPoison.Response{status_code: status_code, body: body }) do
    cond do
    status_code in 400..599 ->
      {{:status_code, status_code}, Poison.decode(body)}
    end
  end

   @spec download_response(HTTPoison.Response.t) :: response
   def download_response(response) do
    case response do
      %HTTPoison.Response{body: body, headers: headers, status_code: 200} ->
        {:ok, %{file: body, headers: get_header(headers, "dropbox-api-result") |> Poison.decode}}
      _-> response   
    end
  end

  def post_request(client, url, body, headers) do
    headers = Map.merge(headers, headers(client))
    HTTPoison.post!(url, body, headers) |> upload_response
  end

  def headers(client) do
    %{ "Authorization" => "Bearer #{client.access_token}" }
  end

  def json_headers do
    %{ "Content-Type" => "application/json" }
  end

  def get_header(headers, key) do
    headers
    |> Enum.filter(fn({k, _}) -> k == key end)
    |> hd
    |> elem(1)
  end

  def upload_request(client, url, data, headers) do
    post_request(client, "#{@upload_url}#{url}", {:file, data}, headers)
  end

  def download_request1(client, url, data, headers) do
    headers = Map.merge(headers, headers(client))
    HTTPoison.post!("#{@upload_url}#{url}", data, headers) |> download_response
  end

  def download_request(client, url, data, headers) do
    headers = Map.merge(headers, headers(client))
    case HTTPoison.post!("#{@upload_url}#{url}", data, headers, [stream_to: self(), async: :once]) do
      resp = %HTTPoison.AsyncResponse{id: id} ->
        receive do
              %HTTPoison.AsyncStatus{ id: ^id, code: status } ->
                case status do
                  200 -> {:ok, async_loop(id, resp, %{file: <<>>})}
                  non_200 -> {:error, non_200}
                end
              whatever -> {:error, whatever}
            end
      whatever -> Logger.debug "#{inspect whatever}"
    end
 
  end
  
  def async_loop id, resp, acc do
    {:ok, ^resp} = HTTPoison.stream_next(resp)
    receive do
      %HTTPoison.AsyncHeaders{ id: ^id, headers: headers } ->
        async_loop(id, resp, Map.put(acc, :headers, (get_header(headers, "dropbox-api-result") |> Poison.decode)))
 
      %HTTPoison.AsyncChunk{ id: ^id, chunk: chunk } ->
        async_loop(id, resp, Map.update(acc, :file, <<>>, &(&1 <> chunk)))
 
      %HTTPoison.AsyncEnd{ id: ^id } -> acc
 
      whatever -> Logger.debug "#{inspect whatever}"
    end
  end
end
