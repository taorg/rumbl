defmodule Rumbl.ImageController do
  use Rumbl.Web, :controller
  alias Rumbl.Image
  alias Rumbl.Repo

  def index(conn, _) do
    images = Repo.all(Image)
    render(conn, "index.html", images: images)
  end

  def new(conn, _) do
    changeset = Image.changeset(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"image" => images_params}) do    
    result = insert_images( images_params["image"])
    conn
    |> put_flash(:info, result)
    |> redirect(to: image_path(conn, :index))
  end

  defp insert_images( img_params_list) do         
    for x <- img_params_list do                
      Image.changeset(%Image{}, %{"image" => x})
      |>Repo.insert
    end      
      |>Enum.map_reduce({0,0}, &evaluate_result(&1, &2) )
      |>elem(1)
      |>display_result
  end  
  defp evaluate_result(x, acc) do
    acc = case x do
          {:ok, image} ->
            put_elem(acc,0,1+elem(acc,0))
          {:error, changeset} ->
            put_elem(acc,1,1+elem(acc,1))       
        end
      {x, acc}                  
  end
  defp display_result(tuple) do
    "Result : #{elem(tuple, 0)} images uploaded, #{elem(tuple, 1)} failed to upload"
  end
end