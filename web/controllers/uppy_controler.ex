defmodule Rumbl.UppyArc do
  use Rumbl.Web, :controller
  alias Rumbl.{Repo, MediasS3, MediasLocal, ImageArcLocal, ImageArc, VideoArcLocal, VideoArc,UppyArc}
    require Logger
  @video_extension_whitelist ~w(.mp4 .mkv)

  def head(conn, _params) do
    IO.inspect " head CONN----------> "
    IO.inspect conn
    IO.inspect " head PARAMS----------> "
    IO.inspect _params
    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")
    |> put_resp_header("tus-extension", "creation,creation-with-upload,termination")
    |> put_resp_header("tus-max-size", "1000000000")
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Upload-Offset", "0")
    |> put_resp_header("Access-Control-Allow-Methods", "POST, GET, HEAD, PATCH, DELETE, OPTIONS")    
    |> send_resp(200,"")
  end

  def options(conn, _params) do
    IO.inspect " options CONN----------> "
    IO.inspect conn
    IO.inspect " options PARAMS----------> "
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
    |> send_resp(200,"")
  end

  def patch(conn, _params) do
  	IO.inspect " patch CONN----------> "
    IO.inspect conn
    IO.inspect " patch PARAMS---------->"
    IO.inspect _params
    %{"uuid" => uuid_media} = _params
    media_size = uuid_media|>String.split("_")|>List.first    
    %Plug.Conn{req_headers: request_headers} = conn
    content_length =Enum.find_value(request_headers, 0, fn {h, v} -> if "content-length" == h, do: v end)
    upload_offset =Enum.find_value(request_headers, 0, fn {h, v} -> if "uploa-offset" == h, do: v end)
    IO.inspect "UUIDFILE: #{uuid_media}  UPLOADLENGTH: #{media_size} CONTENTLENGTH: #{content_length} UPLOADOFFSET: #{upload_offset}" 
    {:ok, body, conn} = Plug.Conn.read_body(conn, length: content_length)
    
    write_patch(conn, uuid_media)

    conn
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Upload-Offset", "0")
    |> send_resp(500, "")

  end

  def post(conn, _params) do

    %Plug.Conn{req_headers: request_headers} = conn
    IO.inspect " post req_headers----------> "
    IO.inspect request_headers
    #index = Enum.find_index(request_headers,fn(x) -> "upload-length" == elem(x,0) end)
    #upload_length = Enum.at(request_headers,index)|>elem(1)
    IO.inspect " post upload_length----------> "   
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
    |> send_resp(200, "")

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
  end
  def transfer conn, wdev do
    case Plug.Conn.read_body(conn, read_length: 4096) do
      {:ok, chunk, conn} -> IO.binwrite(wdev, chunk)
      {:more, chunk, conn} -> IO.binwrite(wdev, chunk); transfer(conn, wdev)
      {:error, reason} -> Logger.error "Chunk read failed #{inspect reason}"
    end
  end







  def save_patch(body, uuid_media) do
    out_file = Path.join("/opt/tmp/", uuid_media)
    with {:ok, wdev} <- File.open(out_file, [:write]) do
      try do
        IO.binwrite(wdev,body)          
      after
        File.close wdev     
        %{size: size} = File.stat! out_file          
      rescue
        error -> IO.inspect "Failed to write #{out_file} #{error}"
      end
    else
      whatever -> IO.inspect "Failed to write #{out_file}: "
    end    
  
  end



  #Rumbl.UppyArc.copy_file "/opt/tmp/rumbl/uploads/led1.jpeg"
  #Rumbl.UppyArc.copy_file "/Users/taorg/Desktop/media/SampleVideo_1280x720_30mb.mp4"
  def copy_file in_file  do
    out_file = Path.join("/opt/tmp/", Ecto.UUID.generate())
    with {:ok, wdev} <- File.open(out_file, [:write]),
         {:ok, rdev} <- File.open(in_file, [:read]) do
        try do
          rdev |> IO.binstream(4096) |> Enum.each(fn x -> IO.binwrite wdev, x end)          
        after
          File.close wdev
          File.close rdev
        rescue
          error -> IO.inspect "Failed to write #{in_file} "
        end
    else
      whatever -> IO.inspect "Failed to write #{in_file}: "
    end
  end
 

end