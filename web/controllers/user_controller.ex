defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  alias Rumbl.User
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    users = Repo.all(Rumbl.User)
    render conn, "index.html", users: users
  end

#SELECT t.name
#FROM tagmaps tm, users u, tags t
#WHERE tm.tag_id = t.id
#AND 1 = tm.user_id
#GROUP BY t.name


  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    user_tags = Repo.all( from t in "tags",
                            join: tm in "tagmaps",
                            on: tm.tag_id == t.id, 
                            where: tm.user_id == ^String.to_integer(id),
                            select: [:tag]                          
                          )
IO.inspect user_tags
    render conn, "show.html", user: user, user_tags: user_tags
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
