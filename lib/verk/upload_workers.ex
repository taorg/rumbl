################################################################
#IMAGE WORKER
################################################################
defmodule Rumbl.ImageWorker do
    alias Rumbl.{Repo, MediasS3, MediasLocal, ImageArc}
    require Logger

  def perform(image_file, content_type, file_local_pk) do
    img_path = Path.expand('./uploads')|>Path.join(content_type)|>Path.join(image_file)
    get_img_info(img_path)
    s3_ecto(image_file, content_type, img_path)
    |>clean_local(img_path,file_local_pk)
  end

  defp get_img_info (img_path) do
    case Porcelain.exec("identify", [img_path]) do
      %Porcelain.Result {err: error_code, out: out, status: 0}->
                        String.replace(out,img_path,"")|>String.split(" ", trim: true)|>Logger.info
      %Porcelain.Result {err: error_code, out: reason, status: status}->
                        Logger.error(["CAN'T EXEC --->",inspect(reason)])
    end
  end

  defp s3_ecto(image_file, content_type, img_path) do
      media_local = %Plug.Upload{:content_type => content_type,:filename => image_file, :path => img_path}
      changeset_s3 = MediasS3.changeset(%MediasS3{}, %{"content_type" => content_type, "image" => media_local})
      Repo.insert(changeset_s3)
  end

  defp clean_local(result,img_path,file_local_pk) do
        case result do
            {:ok, uploaded} ->Logger.info("FILE UPLOADED")
                                media = Repo.get(MediasLocal, file_local_pk)
                                IO.inspect media
                                case Repo.delete media do
                                  {:ok, struct}-> Logger.info("FILE DELETED FROM DB")
                                                         case File.rm(img_path) do
                                                           :ok-> Logger.info("FILE DELETED FROM FS")
                                                           {:error, reason}->Logger.error(["FAIL --->",inspect(reason)])
                                                         end
                                  {:error, changeset}-> Logger.error(["FAIL --->",inspect(changeset)])
                                end

            {:error, changeset} ->Logger.error(["FAIL --->",inspect(changeset)])
         end
  end

end

################################################################
#VIDEO WORKER
################################################################
defmodule Rumbl.VideoWorker do
  alias Rumbl.{Repo, MediasS3, MediasLocal, VideoArc}
  require Logger
  def perform(video_file,content_type,file_local_pk) do
    video_path = Path.expand('./uploads')|>Path.join(content_type)|>Path.join(video_file)

    #https://trac.ffmpeg.org/wiki/FFprobeTips
    get_duration(video_path)
    get_dimensions(video_path)
    s3_ecto(video_file, content_type, video_path)
    |>clean_local(video_path,file_local_pk)
  end

  defp get_duration (video_path) do
    Logger.info "----DURATION ----"
    case Porcelain.exec("ffprobe", ["-v", "error", "-show_entries", "format=duration", "-of", "default=noprint_wrappers=1:nokey=1", video_path]) do
      %Porcelain.Result {err: error_code, out: out, status: 0}->
                         String.replace(out,"\n","")|>String.to_float|>Logger.info
      %Porcelain.Result {err: error_code, out: reason, status: status}->
                        Logger.error(["CAN'T EXEC --->",inspect(reason)])
    end
  end

  defp get_dimensions (video_path) do
    Logger.info "----Dimensions ----"
    case Porcelain.exec("ffprobe", ["-v","error", "-of", "flat=s=_", "-select_streams", "v:0", "-show_entries", "stream=height,width", video_path]) do
      %Porcelain.Result {err: error_code, out: out, status: 0}->
                         String.replace(out,"\n","")|>String.replace("streams_stream_0_width","")
                                                    |>String.replace("streams_stream_0_height","")
                                                    |>String.split("=")
                                                    |>Logger.info
      %Porcelain.Result {err: error_code, out: reason, status: status}->
                        Logger.error(["CAN'T EXEC --->",inspect(reason)])
    end
  end
  defp s3_ecto(video_file, content_type, video_path) do
      media_local = %Plug.Upload{:content_type => content_type,:filename => video_file, :path => video_path}
      changeset_s3 = MediasS3.changeset(%MediasS3{}, %{"content_type" => content_type, "video" => media_local})
      Repo.insert(changeset_s3)
  end

  defp clean_local(result,video_path,file_local_pk) do
        case result do
            {:ok, uploaded} ->Logger.info("FILE UPLOADED")
                                media = Repo.get(MediasLocal, file_local_pk)
                                IO.inspect media
                                case Repo.delete media do
                                  {:ok, struct}-> Logger.info("FILE DELETED FROM DB")
                                                         case File.rm(video_path) do
                                                           :ok-> Logger.info("FILE DELETED FROM FS")
                                                           {:error, reason}->Logger.error(["FAIL --->",inspect(reason)])
                                                         end
                                  {:error, changeset}-> Logger.error(["FAIL --->",inspect(changeset)])
                                end

            {:error, changeset} ->Logger.error(["FAIL --->",inspect(changeset)])
         end
  end

end
