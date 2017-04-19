defmodule Rumbl.AjaxArc do
  use Rumbl.Web, :controller
  alias Rumbl.{Repo, MediasS3, MediasLocal, ImageArcLocal, ImageArc, VideoArcLocal, VideoArc}
    require Logger
  @video_extension_whitelist ~w(.mp4 .mkv)
  def create(conn, _params) do
    IO.inspect _params
    case Map.has_key?(_params, "qqfile") do
        true ->
          do_insert_fine_upload(conn, _params)
        false ->
          do_insert_uppy(conn, _params)
          
    end

  end



################################################################
#FineUpload
################################################################
  defp do_delete_fine_upload(conn, _params) do
    send_resp(conn, 200, "{\"success\":false}")
  end

  defp do_insert_fine_upload(conn, _params) do
      %{"qqfile" => media_params} = _params
      %{"qquuid" => _qquuid} = _params
      %{"qqtotalfilesize" => _qqtotalfilesize} = _params

      content_type = Map.get(media_params, :content_type)
      file_extension = Map.get(media_params, :filename)
                  |> Path.extname() |> String.downcase()
      file_renamed =  _qquuid<>file_extension
      renamed_media = Map.put(media_params, :filename , file_renamed)

      Logger.debug(["ARC CHANGESET --->",
                    inspect(%{"content_type" => content_type, "filesize" => _qqtotalfilesize , "image" => renamed_media})
                  ])

      cond do
          VideoArcLocal.is_valid?(file_extension) ->
                changeset = MediasLocal.changeset(%MediasLocal{}, %{"content_type" => content_type,
                                                                    "filesize" => _qqtotalfilesize ,
                                                                    "video" => renamed_media})
          ImageArcLocal.is_valid?(file_extension) ->
                changeset = MediasLocal.changeset(%MediasLocal{}, %{"content_type" => content_type,
                                                                    "filesize" => _qqtotalfilesize ,
                                                                     "image" => renamed_media})
      end
      result = Repo.insert(changeset)
      %Rumbl.MediasLocal{id: file_local_pk} = elem(result,1)
      Logger.debug(["INSERT RESULT --->",inspect(result)])

      case result do
          {:ok, uploaded} ->
            cond do
                VideoArc.is_valid?(file_extension) ->
                      Logger.error ("VIDEO UPLOADED")
                      #Verk.enqueue(%Verk.Job{queue: :default, class: "Rumbl.VideoWorker", args: [file_renamed,content_type,file_local_pk], max_retry_count: 5})
                      Rumbl.VideoWorker.perform(file_renamed,content_type,file_local_pk)
                ImageArc.is_valid?(file_extension) ->
                      Logger.error ("IMAGE UPLOADED")
                      #Verk.enqueue(%Verk.Job{queue: :default, class: "Rumbl.ImageWorker", args: [file_renamed,content_type,file_local_pk], max_retry_count: 5})
                      Rumbl.ImageWorker.perform(file_renamed,content_type,file_local_pk)
                true -> {:error, changeset}
            end
            conn
            |>put_resp_content_type("text/plain")
            |>send_resp( 200, "{\"success\":true}")
          {:error, changeset} ->
            conn
            |>put_resp_content_type("text/plain")
            |>send_resp( 200, "{\"success\":false, \"error\":  \"File format not  valid\", \"preventRetry\": false}")
      end
  end


################################################################
#Uppy
# %Plug.Upload{content_type: "image/jpeg", filename: "led1.jpeg",
# path: "/var/folders/r8/zd35qmfd7675_lkv64zn3ftr0000gn/T//plug-1492/multipart-342625-442633-4"}
################################################################
  defp do_insert_uppy1(conn, _params) do
    #IO.inspect conn
    IO.inspect "do_insert_uppy1-----------------"
    IO.inspect _params
      %{"files" => media_params} = _params
    IO.inspect media_params |>List.first  
      changeset = MediasLocal.changeset(%MediasLocal{}, %{"image" => media_params|>List.first})
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
  defp do_insert_uppy(conn, _params) do
    IO.inspect conn
    IO.inspect "do_insert_uppy1----------------->"  

    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> put_resp_header("Content-Length", "0")
    |> put_resp_header("tus-extension", "creation,creation-with-upload,termination")
    |> put_resp_header("tus-max-size", "1000000000")
    |> put_resp_header("Tus-Resumable", "1.0.0")
    |> put_resp_header("tus-version", "1.0.0")
    |> put_resp_header("Access-Control-Allow-Methods", "POST, GET, HEAD, PATCH, DELETE, OPTIONS")
    |> send_resp(200, "")
  end

end
