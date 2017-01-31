defmodule Rumbl.User do
  use Rumbl.Web, :model
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    many_to_many :tags, Rumbl.Tag, join_through: "tagmaps"
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username))
    |> validate_length(:username, min: 1, max: 20)
    |> Ecto.Changeset.put_assoc(:tags, parse_tags(params))
  end

# params = %{"name" => "", "password" => "1", "username" => "1", "usertags" => "[{\"tag\":\"1\"},{\"tag\":\"2\"},{\"tag\":\"3\"}]"}
# Rumbl.User.parse_tags(params)
  def parse_tags(params)  do
    cond do
       is_atom(params) -> ""
       true -> 
             (params["usertags"])
             |>String.replace("\"","")
             |>String.replace_leading("[{","")
             |>String.replace_trailing("}]","")
             |>String.replace("tag:","")
             |>String.replace("},{", ",")
             |>String.split(",")
             |> Enum.map(&String.trim/1)
             |> Enum.reject(& &1 == "")
             |> Enum.map(&get_or_insert_tag/1)
    end

  end


  def get_or_insert_tag(name) do
    Rumbl.Repo.insert!(%Rumbl.Tag{name: name},
               on_conflict: [set: [name: name]], conflict_target: :name)

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
