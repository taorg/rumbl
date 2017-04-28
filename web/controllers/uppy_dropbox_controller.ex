defmodule Rumbl.UppyDropbox do
  use Rumbl.Web, :controller
  require Logger
  import Plug.Conn 
        plug :fetch_session

  def gauth(conn, _params) do
    IO.puts "AUTH-------UppyDropbox---------------" 
    IO.puts "DROPBOX_TOKEN: #{get_session(conn,"dropbox")}"   
    if get_session(conn,"dropbox") do
      authenticated = true
    else
      authenticated = false
    end
    conn 
    |> send_resp(200,Poison.encode! %{authenticated: authenticated})
  end

  def glist(conn, _params) do
    IO.puts "LIST-------UppyDropbox---------------"    
    IO.inspect _params
    case Map.has_key?(_params,"path") do
      true -> path =  URI.encode(Map.fetch!(_params,"path"))
      _    -> paht = ""
    end
      
    metadata = ElixirDropbox.Client.new(get_session(conn,"dropbox"))
              |>ElixirDropbox.Files.get_v1_metadata(path) 

      case metadata do 
      {{:status_code, status_code}, {:error, {:invalid, body, _}}} ->Logger.error( "Status code #{status_code} body #{body}")
                                http_code=status_code
                                send_metadata= ElixirDropbox.Client.new(get_session(conn,"dropbox"))
                                                |>ElixirDropbox.Files.get_v1_metadata("")                                     
      _ -> Logger.info("Dropbox metadata successfully retrived"); 
                                http_code=200
                                send_metadata = metadata 
            
    end

    conn 
    |> send_resp(http_code,Poison.encode! send_metadata)
  end



  def post_file(conn, _params) do
    IO.puts "POST__FILE-------UppyDropbox---------------"    
    IO.inspect _params
    IO.inspect "----------------------------------------"
    case Map.has_key?(_params,"path") do
      true -> path =  Path.join("/", Map.fetch!(_params,"path"))
      _    -> paht = ""
    end
      
    response = ElixirDropbox.Client.new(get_session(conn,"dropbox"))
              |>ElixirDropbox.Files.download(path) 
    case response do
        {:ok, %{file: body, headers: headers}} -> 
                {:ok, %{"name"=> name}} = headers
                uuid_file =  Ecto.UUID.generate()<>Path.extname(name)
                uuid_path = Path.expand('./uploads')|>Path.join(uuid_file)
                File.write!(uuid_path, body)
                Stash.load(:uppy_cache, Path.expand('./uploads')|>Path.join("uppy.db"))
                Stash.set(:uppy_cache, "name_"<>uuid_file, name)
                Stash.persist(:uppy_cache, Path.expand('./uploads')|>Path.join("uppy.db"))
        _->     Logger.error( " Failed to download #{inspect response}")
      end
    
    conn 
    |> send_resp(200,Poison.encode! %{token: uuid_file})
  end

  def static_url(conn, _params) do
    IO.puts "static_url----------------------"
    %{"uuid" => uuid_media} = _params
        
    conn 
    |> redirect(to: "/uploads/#{uuid_media}")
  end


  defp count_seconds_to_expire_date(date) do
    expire_secs = Date.now |> Date.diff(date, :secs)
    expire_secs
  end



end