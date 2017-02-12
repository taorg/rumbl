defmodule Rumbl.ImageWorker do
    alias Rumbl.ImageArc
    alias Porcelain.Result
  def perform(img_file) do
    #aws_result = VideoArc.store Path.expand('./uploads')|>Path.join(rename_file)     
    IO.inspect "----Work DONE ----"
    result = Porcelain.exec("identify", [img_file])|>Map.get(:out)|>String.replace(img_file,"")|>String.split(" ", trim: true)
    IO.inspect result  
  end
end

defmodule Rumbl.VideoWorker do
  alias Rumbl.VideoArc
  def perform(renamed_file) do
    #aws_result = ImageArc.store Path.expand('./uploads')|>Path.join(renamed_file)
    IO.inspect "----Work DONE ----"
    IO.inspect renamed_file
  end
end