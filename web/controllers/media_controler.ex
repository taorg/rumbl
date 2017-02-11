defmodule Rumbl.AjaxArc do
  use Rumbl.Web, :controller
  alias Rumbl.Medias
  alias Rumbl.MediasLocal
  alias Rumbl.Repo
  alias Rumbl.ImageArc
  alias Rumbl.VideoArc
  alias Rumbl.ImageArcLocal

  @video_extension_whitelist ~w(.mp4 .mkv)
  def create(conn, _params) do 
    IO.inspect "--------PARAMS-----------"
    IO.inspect _params
    case Map.has_key?(_params, "qqfile") do
        true ->
          do_insert_fine_upload(conn, _params)
        false ->
          do_insert_dropzone(conn, _params)
    end  
    
  end

  def delete(conn, _params) do   
    send_resp(conn, 200, "{\"success\":false}")   
  end


  defp do_insert_fine_upload(conn, _params) do
      %{"qqfile" => media_params} = _params  
      %{"qquuid" => _qquuid} = _params
      %{"qqtotalfilesize" => _qqtotalfilesize} = _params
  
      content_type = Map.get(media_params, :content_type)      
      file_extension = Map.get(media_params, :filename)                  
                  |> Path.extname() |> String.downcase()
      rename_file =  _qquuid<>file_extension           
      renamed_media = Map.put(media_params, :filename , rename_file)      
      case  Enum.member?(@video_extension_whitelist, file_extension) do
          true ->changeset = MediasLocal.changeset(%MediasLocal{}, %{"content_type" => content_type, "filesize" => _qqtotalfilesize , "video" => renamed_media})
          false ->changeset = MediasLocal.changeset(%MediasLocal{}, %{"content_type" => content_type, "filesize" => _qqtotalfilesize , "image" => renamed_media})
           
      end 
      result = Repo.insert(changeset) 
      IO.inspect "--------result-----------"      
      IO.inspect result
      
      case result do
          {:ok, uploaded} ->
            case  Enum.member?(@video_extension_whitelist, file_extension) do              
              true ->aws_result = VideoArc.store Path.expand('./uploads')|>Path.join(rename_file) 
              false ->aws_result = ImageArc.store Path.expand('./uploads')|>Path.join(rename_file) 
            end
            IO.inspect aws_result 
            conn
            |>put_resp_content_type("text/plain")
            |>send_resp( 200, "{\"success\":true}")
          {:error, changeset} ->
            conn
            |>put_resp_content_type("text/plain")
            |>send_resp( 200, "{\"success\":false, \"error\":  \"File format not  valid\", \"preventRetry\": false}")     
      end     
  end
  defp do_insert_dropzone(conn, _params) do
      %{"file" => media_params} = _params
      changeset = MediasLocal.changeset(%MediasLocal{}, %{"image" => media_params})
      result = Repo.insert(changeset) 
      case result do
          {:ok, uploaded} ->
            conn
            |> put_resp_content_type("text/plain")
            |> send_resp(200, "File saved")
          {:error, changeset} ->
            conn
            |> put_resp_content_type("text/plain")
            |>send_resp(415, "415 ERROR : Media not suported")     
      end     
  end

end