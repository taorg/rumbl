defmodule Rumbl.VideoArc do
  use Arc.Definition
  use Arc.Ecto.Definition

  #def __storage, do: Arc.Storage.Local
  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition

  @versions [:original, :thumb, :screen]
  @extension_whitelist ~w(.mp4 .mkv)

  def validate({file, _}) do   
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    :true
  end

  def is_valid?(file_extension) do
    Enum.member?(@extension_whitelist, file_extension)
  end
  
  def transform(:thumb, _) do
    {:ffmpeg, fn(input, output) -> "-itsoffset -1 -i #{input} -vcodec png -vframes 1 -f rawvideo  -y -filter:v scale='300:-1' #{output}" end, :png}
    #http://stackoverflow.com/questions/14551102/with-ffmpeg-create-thumbnails-proportional-to-the-videos-ratio
  end

  def transform(:screen, _) do
    {:ffmpeg, fn(input, output) -> "-itsoffset -1 -i #{input} -vcodec png -vframes 1 -f rawvideo  -y #{output}" end, :jpg}
  end


  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Whitelist file extensions:
  # def validate({file, _}) do
  #   ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  # end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  # Override the persisted filenames:
  # def filename(version, _) do
  #   version
  # end

  # Override the storage directory:
  # def storage_dir(version, {file, scope}) do
  #   "uploads/user/avatars/#{scope.id}"
  # end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
