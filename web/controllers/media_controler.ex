defmodule Rumbl.MediaControler do
  use Rumbl.Web, :controller
  alias Rumbl.Image
  alias Rumbl.Repo
  

  def create(conn, _params) do 
    IO.inspect "--------PARAMS-----------"
    IO.inspect _params

    %{"qqfile" => media_params} = _params  

    IO.inspect "--------media_params-----------"
    IO.inspect media_params
    changeset = Image.changeset(%Image{}, %{"image" => media_params})
    result = Repo.insert(changeset)  
    case result do
          {:ok, image} ->
            send_resp(conn, 200, "{\"success\":true}")
          {:error, changeset} ->
            send_resp(conn, 200, "{\"success\":false}")     
    end     
    
  end

  def delete(conn, _params) do   
    IO.inspect _params
    send_resp(conn, 200, "{\"success\":false}")   
  end


end