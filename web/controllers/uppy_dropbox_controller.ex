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
    if Map.has_key?(_params,"dir_file") do
     dir_file =  "/"<>Map.fetch!(_params,"dir_file")
    else
      dir_file=""
    end  
    client = ElixirDropbox.Client.new(get_session(conn,"dropbox"))
    
    conn 
    |> send_resp(200,Poison.encode! ElixirDropbox.Files.get_v1_metadata(client,dir_file))
  end

  def get_file(conn, _params) do
    IO.puts "POST_FILE-------UppyDropbox---------------"    
    IO.inspect _params
    conn 
    |> send_resp(200,Poison.encode! %{})
  end

  def post_file(conn, _params) do
    IO.puts "LIST-------UppyDropbox---------------"    
    IO.inspect _params
    conn 
    |> send_resp(200,Poison.encode! %{})
  end



  defp count_seconds_to_expire_date(date) do
    expire_secs = Date.now |> Date.diff(date, :secs)
    expire_secs
  end

end