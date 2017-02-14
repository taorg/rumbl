################################################################
#IMAGE WORKER
################################################################
defmodule Rumbl.ImageWorker do
    alias Rumbl.{Repo, MediasS3, MediasLocal, ImageArc}

  def perform(image_file, content_type, file_local_pk) do
    img_path = Path.expand('./uploads')|>Path.join(image_file)
    get_img_info(img_path)
    s3_ecto(image_file, content_type, img_path)
  end

  defp get_img_info (img_path) do
    IO.inspect "----Work DONE ----"
    case Porcelain.exec("identify", [img_path]) do
      %Porcelain.Result {err: error_code, out: out, status: 0}->
                        String.replace(out,img_path,"")|>String.split(" ", trim: true)|>IO.inspect
      %Porcelain.Result {err: error_code, out: reason, status: status}->
                        IO.inspect reason

    end
  end

  defp s3_ecto(image_file, content_type, img_path) do
      media_local = %Plug.Upload{:content_type => content_type,:filename => image_file, :path => img_path}
      IO.inspect "--------media_local-----------"
      IO.inspect media_local
      changeset_s3 = MediasS3.changeset(%MediasS3{}, %{"image" => media_local})
      IO.inspect "--------changeset_s3-----------"
      IO.inspect changeset_s3
      result = Repo.insert(changeset_s3)
      IO.inspect result
  end
end

################################################################
#VIDEO WORKER
################################################################
defmodule Rumbl.VideoWorker do
  alias Rumbl.{Repo, MediasS3, MediasLocal, VideoArc}
  def perform(video_file,content_type,file_local_pk) do
    video_path =Path.expand('./uploads')|>Path.join(video_file)
    #https://trac.ffmpeg.org/wiki/FFprobeTips
    #aws_result = ImageArc.store Path.expand('./uploads')|>Path.join(video_path)
    get_duration(video_path)
    get_dimensions(video_path)
    s3_ecto(video_file, content_type, video_path)
  end

  defp get_duration (video_path) do
    IO.inspect "----DURATION ----"
    case Porcelain.exec("ffprobe", ["-v", "error", "-show_entries", "format=duration", "-of", "default=noprint_wrappers=1:nokey=1", video_path]) do
      %Porcelain.Result {err: error_code, out: out, status: 0}->
                         String.replace(out,"\n","")|>String.to_float|>IO.inspect
      %Porcelain.Result {err: error_code, out: reason, status: status}->
                        IO.inspect reason
    end
  end

  defp get_dimensions (video_path) do
    IO.inspect "----Dimensions ----"
    case Porcelain.exec("ffprobe", ["-v","error", "-of", "flat=s=_", "-select_streams", "v:0", "-show_entries", "stream=height,width", video_path]) do
      %Porcelain.Result {err: error_code, out: out, status: 0}->
                         String.replace(out,"\n","")|>String.replace("streams_stream_0_width","")
                                                    |>String.replace("streams_stream_0_height","")
                                                    |>String.split("=")
                                                    |>IO.inspect
      %Porcelain.Result {err: error_code, out: reason, status: status}->
                        IO.inspect reason
    end
  end
  defp s3_ecto(video_file, content_type, video_path) do
      media_local = %Plug.Upload{:content_type => content_type,:filename => video_file, :path => video_path}
      IO.inspect "--------media_local-----------"
      IO.inspect media_local
      changeset_s3 = MediasS3.changeset(%MediasS3{}, %{"video" => media_local})
      IO.inspect "--------changeset_s3-----------"
      IO.inspect changeset_s3
      result = Repo.insert(changeset_s3)
      IO.inspect result
  end


end
