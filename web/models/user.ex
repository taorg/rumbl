defmodule Rumbl.User do
  use Rumbl.Web, :model
  use Ecto.Schema
  use Arc.Ecto.Schema

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :avatar, Rumbl.ImageArc.Type
    #has_many :medias, Rumbl.Medias
    many_to_many :tags, Rumbl.Tag, join_through: "tagmaps"
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username))
    |> validate_length(:username, min: 1, max: 20)
    |> Ecto.Changeset.put_assoc(:tags, parse_tags(params))
  end





# c("./web/models/user.ex")
#Poison.decode "[{\"tag\":\"1\"},{\"tag\":\"2\"},{\"tag\":\"3\"}]", [keys: :atoms]
# params = %{"name" => "", "password" => "1", "username" => "1", "usertags" => "[{\"tag\":\"1\"},{\"tag\":\"2\"},{\"tag\":\"3\"}]"}
# Rumbl.User.parse_tags(params)
  def parse_tags(params)  do
    cond do
       is_atom(params) -> params
       true ->
             (params["usertags"])
             |>Poison.decode([keys: :atoms])
             |>elem(1)
             |>Enum.map(fn(x) ->  Map.get(x,:tag) end)
             |>Enum.map(&get_or_insert_tag/1)
    end

  end


  defp get_or_insert_tag(tag) do
    Rumbl.Repo.insert!(%Rumbl.Tag{tag: tag},
               on_conflict: [set: [tag: tag]], conflict_target: :tag)

  end






  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
