defmodule Rumbl.UppyArc do
  use Rumbl.Web, :controller
  alias Rumbl.{Repo, MediasS3, MediasLocal, ImageArcLocal, ImageArc, VideoArcLocal, VideoArc,UppyArc}
    require Logger
  @video_extension_whitelist ~w(.mp4 .mkv)

  def get(conn, _params) do
    IO.inspect "GET----------------------"
    IO.inspect conn
    %{"uuid" => uuid_media} = _params
        
    conn 
    |> send_resp(200,"")
  end

  def options(conn, _params) do
    IO.inspect "OPTIONS----------------------"
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



  def post(conn, _params) do
    %Plug.Conn{req_headers: request_headers} = conn
    upload_length =Enum.find_value(request_headers, 0, fn {h, v} -> if "upload-length" == h, do: v end)     
    IO.inspect upload_length
    srv_location = "http://localhost:3000/pharc/umedia/#{create_u_file(upload_length)}"
 
    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")
    |> put_resp_header("tus-max-size", "1000000000")
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Location", srv_location)
    |> send_resp(201, "")

  end


  def head(conn, _params) do
    IO.inspect "HEAD----------------------"
    %{"uuid" => uuid_media} = _params
    srv_upload_offset = get_uuid_file_size(uuid_media)
    #uuid_media_size=uuid_media|>String.split("_")|>List.first|>String.to_integer
    uuid_media_size = Stash.get(:uppy_cache, uuid_media)|>String.to_integer
    srv_upload_length = uuid_media_size - srv_upload_offset

    IO.inspect  "SRV_UPLOAD_LENGTH: #{srv_upload_length}"  
    IO.inspect  "SRV_UPLOAD_OFFSET: #{srv_upload_offset}"

    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")    
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Upload-Length", "#{srv_upload_length}") 
    |> put_resp_header("Upload-Offset", "#{srv_upload_offset}")    
    |> send_resp(200, "")
  end

  def patch(conn, _params) do
    IO.inspect "PATCH----------------------"
    %{"uuid" => uuid_media} = _params
    #media_size = uuid_media|>String.split("_")|>List.first|>String.to_integer    
    media_size = Stash.get(:uppy_cache, uuid_media)|>String.to_integer
    %Plug.Conn{req_headers: request_headers} = conn
    cli_content_length =Enum.find_value(request_headers, 0, fn {h, v} -> if "content-length" == h, do: v end)
    cli_upload_offset =Enum.find_value(request_headers, 0, fn {h, v} -> if "upload-offset" == h, do: v end)    
    media_size_tuple = write_patch(conn, uuid_media)
    srv_prepatch_size = elem(media_size_tuple, 0)
    srv_upload_offset = elem(media_size_tuple, 1)

  
    #if cli_content_length==srv_upload_offset || media_size == srv_media_size do
      http_code=204
      http_msg="No Content"  
    #else
    #  http_code=409
    #  http_msg="Conflict" 
    #end

    IO.inspect  "UUIDFILE: #{uuid_media}"  
    IO.inspect  "SRV TOTAL MEDIA SIZE: #{media_size}"
    IO.inspect  "CLI CONTENTLENGTH: #{cli_content_length}" 
    IO.inspect  "CLI UPLOADOFFSET: #{cli_content_length}" 
    IO.inspect  "SRV UPLOADOFFSET #{srv_upload_offset}"
    IO.inspect  "SRV PRE PATCH SIZE #{srv_prepatch_size}"
    IO.inspect  "SRV UPLOADOFFSET SEND #{srv_upload_offset}"
    IO.inspect  "HTTP CODE #{http_code}"
    
    conn
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Upload-Offset", "#{srv_upload_offset}")
    |> send_resp(http_code, http_msg)

  end



  #Rumbl.UppyArc.create_u_file()  :delayed_write
  def create_u_file(upload_length) do 
    uuid_file = upload_length<>"_"<>Ecto.UUID.generate()    
    file_out_path = Path.expand('./uploads')|>Path.join(uuid_file)
    File.touch!(file_out_path)
    Stash.load(:uppy_cache, Path.expand('./uploads')|>Path.join("uppy.db"))
    Stash.set(:uppy_cache, uuid_file, upload_length)
    Stash.persist(:uppy_cache, Path.expand('./uploads')|>Path.join("uppy.db"))
    uuid_file
  end


  def write_patch(conn, uuid_media) do
    out_file = Path.expand('./uploads')|>Path.join(uuid_media)     
    initial_file_size = File.stat!(out_file)   
                    |>Map.get(:size)
                    
    with {:ok, wdev} <- File.open(out_file, [:append]) do
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
    final_file_size = File.stat!(out_file)   
                  |>Map.get(:size)
    {initial_file_size,final_file_size}              
  end

  #Rumbl.UppyArc.copy_file "/opt/tmp/rumbl/uploads/led1.jpeg"
  #Rumbl.UppyArc.copy_file "/Users/taorg/Desktop/media/SampleVideo_1280x720_30mb.mp4"
  def append_chunck in_file  do
    out_file = Path.expand('./uploads')|>Path.join(Ecto.UUID.generate())
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


  def transfer(conn, wdev) do
    case Plug.Conn.read_body(conn) do
      {:ok, chunk, conn} -> IO.binwrite(wdev, chunk)                            
      {:more, chunk, conn} -> IO.binwrite(wdev, chunk); transfer(conn, wdev)                                                        
      {:error, reason} -> Logger.error "Chunk read failed #{inspect reason}"                            
    end
    
  end

  def get_uuid_file_size(uuid_media) do
      uuid_path = Path.expand('./uploads')|>Path.join( uuid_media)
      case File.stat uuid_path do
      {:ok, %{size: uuid_path_size}} -> uuid_path_size
      {:error, reason} -> Logger.error "Failed to write #{uuid_path} #{Exception.format(:error, reason)}"
                          uuid_path_size = 0
    end
  end

end