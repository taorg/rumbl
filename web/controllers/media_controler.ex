defmodule Rumbl.AjaxArc do
  use Rumbl.Web, :controller
  alias Rumbl.Medias
  alias Rumbl.Repo
  alias Rumbl.ImageArc

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
    IO.inspect _params
    send_resp(conn, 200, "{\"success\":false}")   
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

  defp do_insert_fine_upload(conn, _params) do
      %{"qqfile" => media_params} = _params  
      %{"qquuid" => _qquuid} = _params
      extension = Map.get(media_params, :filename)                  
                  |> Path.extname() |> String.downcase()
      renamed_media = Map.put(media_params, :filename , _qquuid <>"."<>extension)
      changeset = Medias.changeset(%Medias{}, %{"image" => renamed_media})
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
            |>send_resp( 200, "{\"success\":false, \"error\":  \"File format not  valid\", \"preventRetry\": true}")     
      end     

  end


end