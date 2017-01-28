defmodule Rumbl.TagController do
  use Rumbl.Web, :controller
  alias Rumbl.Tag

  def index(conn, _params) do
    tags = Repo.all(Rumbl.Tag)
    render conn, "index.html", tags: tags
  end

  def show(conn, %{"id" => id}) do
    tag = Repo.get(Rumbl.Tag, id)
    render conn, "show.html", tag: tag
  end

  def new(conn, _params) do
    changeset = Tag.changeset(%Tag{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"tag" => tag_params}) do
    changeset = Tag.changeset(%Tag{}, tag_params)
    case Repo.insert(changeset) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "#{tag.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
