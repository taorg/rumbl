defmodule Rumbl.UppyArc do
  use Rumbl.Web, :controller
  alias Rumbl.{Repo, MediasS3, MediasLocal, ImageArcLocal, ImageArc, VideoArcLocal, VideoArc}
    require Logger
  @video_extension_whitelist ~w(.mp4 .mkv)

  def head(conn, _params) do
    IO.inspect " HEAD CONN----------> "
    IO.inspect conn
    IO.inspect " HEAD PARAMS----------> "
    IO.inspect _params

    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")
    |> put_resp_header("tus-extension", "creation,creation-with-upload,termination")
    |> put_resp_header("tus-max-size", "1000000000")
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Upload-Offset", "0")
    |> put_resp_header("Upload-Length", "10")
    |> put_resp_header("Access-Control-Allow-Methods", "POST, GET, HEAD, PATCH, DELETE, OPTIONS")
    |> send_resp(204,"")
  end

  def options(conn, _params) do
    IO.inspect " OPTIONS CONN----------> "
    IO.inspect conn
    IO.inspect " OPTIONS PARAMS----------> "
    IO.inspect _params

    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")
    |> put_resp_header("tus-extension", "creation,creation-with-upload,termination")
    |> put_resp_header("tus-max-size", "1000000000")
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Upload-Offset", "0")
    |> put_resp_header("Upload-Length", "10")
    |> put_resp_header("Access-Control-Allow-Methods", "POST, GET, HEAD, PATCH, DELETE, OPTIONS")
    |> send_resp(204,"")
  end

  def patch(conn, _params) do
  	IO.inspect " UPDATE CONN----------> "
    IO.inspect conn
    IO.inspect " UPDATE PARAMS---------->"
    IO.inspect _params
    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")
    |> put_resp_header("tus-extension", "creation,creation-with-upload,termination")
    |> put_resp_header("tus-max-size", "1000000000")
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Upload-Offset", "0")
    |> put_resp_header("Upload-Length", "10")
    |> put_resp_header("Access-Control-Allow-Methods", "POST, GET, HEAD, PATCH, DELETE, OPTIONS")
    |> send_resp(200, "")

  end
  def post(conn, _params) do
  	IO.inspect " UPDATE CONN----------> "
    IO.inspect conn
    IO.inspect " UPDATE PARAMS---------->"
    IO.inspect _params
    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")
    |> put_resp_header("tus-extension", "creation,creation-with-upload,termination")
    |> put_resp_header("tus-max-size", "1000000000")
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Location", "https://localhost:3000/pharc/5b7ee1ef17bbb6962e6194ec06d5ad02")
    |> send_resp(200, "")

  end

end