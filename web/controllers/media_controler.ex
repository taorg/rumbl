defmodule Rumbl.AjaxArc do
  use Rumbl.Web, :controller
  alias Rumbl.Medias
  alias Rumbl.Repo
  alias Rumbl.ImageArc
  alias Rumbl.VideoArc
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
      file_extension = Map.get(media_params, :filename)                  
                  |> Path.extname() |> String.downcase()
      rename_file =  _qquuid<>file_extension           
      renamed_media = Map.put(media_params, :filename , rename_file)
      
      case  Enum.member?(@video_extension_whitelist, file_extension) do
          true ->changeset = Medias.changeset(%Medias{}, %{"video" => renamed_media})
          false ->changeset = Medias.changeset(%Medias{}, %{"image" => renamed_media})
      end 
      IO.inspect "--------changeset-----------"
      IO.inspect changeset
      result = Repo.insert(changeset) 
      IO.inspect "--------result-----------"
      IO.inspect result
      
      

      case result do
          {:ok, image} ->
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
      changeset = Medias.changeset(%Medias{}, %{"image" => media_params})
      result = Repo.insert(changeset) 
      case result do
          {:ok, image} ->
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