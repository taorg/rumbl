defmodule Rumbl.Medias do
  use Rumbl.Web, :model
  use Arc.Ecto.Schema

  schema "medias" do
    field :image, Rumbl.ImageArc.Type
    field :video, Rumbl.VideoArc.Type
    field :content_type, :string
    belongs_to :users, Rumbl.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:image,:video,:content_type])
    |> cast_attachments(params, [:image, :video])
    |> validate_required([:image])
  end
end
