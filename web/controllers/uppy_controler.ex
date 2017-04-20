defmodule Rumbl.UppyArc do
  use Rumbl.Web, :controller
  alias Rumbl.{Repo, MediasS3, MediasLocal, ImageArcLocal, ImageArc, VideoArcLocal, VideoArc,UppyArc}
    require Logger
  @video_extension_whitelist ~w(.mp4 .mkv)

  def head(conn, _params) do
    %{"uuid" => uuid_media} = _params
    uuid_path = Path.join("/opt/tmp/", uuid_media)
    case File.stat uuid_path do
      {:ok, %{size: uuid_path_size}} -> uuid_path_size
      {:error, reason} -> Logger.error "Failed to write #{uuid_path} #{Exception.format(:error, reason)}"
                          uuid_path_size = 0
    end
    uuid_media_size=uuid_media|>String.split("_")|>List.first|>String.to_integer
    #upload_length = uuid_media_size - uuid_path_size
    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")    
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Upload-Length", "0") 
    |> put_resp_header("Upload-Offset", "#{uuid_path_size}")    
    |> send_resp(200,"OK")
  end

  def options(conn, _params) do
    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")
    |> put_resp_header("access-control-allow-headers","Origin, X-Requested-With, Content-Type, Upload-Length, Upload-Offset, Tus-Resumable, Upload-Metadata")
    |> put_resp_header("Access-Control-Allow-Methods", "POST, GET, HEAD, PATCH, DELETE, OPTIONS")
    |> put_resp_header("tus-extension", "creation,creation-with-upload,termination")
    |> put_resp_header("tus-max-size", "1000000000")
    |> put_resp_header("tus-version", "1.0.0")   
    |> put_resp_header("Upload-Offset", "0")     
    |> send_resp(200,"")
  end

  def patch(conn, _params) do
    %{"uuid" => uuid_media} = _params
    media_size = uuid_media|>String.split("_")|>List.first    
    %Plug.Conn{req_headers: request_headers} = conn
    content_length =Enum.find_value(request_headers, 0, fn {h, v} -> if "content-length" == h, do: v end)
    upload_offset =Enum.find_value(request_headers, 0, fn {h, v} -> if "uploa-offset" == h, do: v end)
    file_upload_offset = write_patch(conn, uuid_media)
    if content_length==file_upload_offset do
      http_code=204
      http_msg="No Content"  
    else
      http_code=409
      http_msg="Conflict" 
    end

    IO.inspect "UUIDFILE: #{uuid_media}  UPLOADLENGTH: #{media_size} CONTENTLENGTH: #{content_length} " 
    IO.inspect "UPLOADOFFSET: #{upload_offset} FILE UPLOAD OFFSET #{file_upload_offset}"
    conn
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Upload-Offset", "#{file_upload_offset}")
    |> send_resp(http_code, http_msg)

  end

  def post(conn, _params) do
    %Plug.Conn{req_headers: request_headers} = conn
    upload_length =Enum.find_value(request_headers, 0, fn {h, v} -> if "upload-length" == h, do: v end)     
    IO.inspect upload_length
    location = "http://localhost:3000/pharc/umedia/#{create_u_file(upload_length)}"
 
    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")
    |> put_resp_header("tus-extension", "creation,creation-with-upload,termination")
    |> put_resp_header("tus-max-size", "1000000000")
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Location", location)
    |> send_resp(201, "")

  end

  #Rumbl.UppyArc.create_u_file()  :delayed_write
  def create_u_file(upload_length) do     
    uuid_file = upload_length<>"_"<>Ecto.UUID.generate()
    file_out_path = Path.join("/opt/tmp/",uuid_file)
    File.touch!(file_out_path)
    uuid_file
  end

  def write_patch(conn, uuid_media) do
    out_file = Path.join("/opt/tmp/", uuid_media)    
    with {:ok, wdev} <- File.open(out_file, [:write]) do
      try do
        transfer(conn, wdev)
      after
        File.close wdev
      rescue
        error -> Logger.error "Failed to write #{out_file} #{Exception.format(:error, error)}"
      end
    else
     whatever -> Logger.error "Failed to write #{out_file}: #{inspect whatever}"
    end
    case File.stat out_file do
      {:ok, %{size: size}} -> size
      {:error, reason} -> Logger.error "Failed to write #{out_file} #{Exception.format(:error, reason)}"
                          0
    end
  end

  def transfer conn, wdev do
    case Plug.Conn.read_body(conn, read_length: 4096) do
      {:ok, chunk, conn} -> IO.binwrite(wdev, chunk)
      {:more, chunk, conn} -> IO.binwrite(wdev, chunk); transfer(conn, wdev)
      {:error, reason} -> Logger.error "Chunk read failed #{inspect reason}"
    end
  end

end