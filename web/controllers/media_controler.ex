defmodule Rumbl.AjaxArc do
  use Rumbl.Web, :controller
  alias Rumbl.Medias
  alias Rumbl.Repo
  alias Rumbl.ImageArc

  def create(conn, _params) do 
    IO.inspect "--------PARAMS-----------"
    IO.inspect _params

    %{"qqfile" => media_params} = _params  
    %{"qquuid" => _qquuid} = _params
    IO.inspect "--------media_params-----------"
    extension = Map.get(media_params, :filename)
                |>String.slice(-4,4)
    renamed_media = Map.put(media_params, :filename , _qquuid <> extension)

    IO.inspect media_params
    IO.inspect renamed_media
    changeset = Medias.changeset(%Medias{}, %{"image" => renamed_media})
    result = Repo.insert(changeset) 
    IO.inspect "--------result-----------"
    IO.inspect result 
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