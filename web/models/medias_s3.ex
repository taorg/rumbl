defmodule Rumbl.MediasS3 do
  use Rumbl.Web, :model
  use Arc.Ecto.Schema

  schema "medias" do
    field :image, Rumbl.ImageArc.Type
    field :video, Rumbl.VideoArc.Type
    field :filesize, :integer
    field :content_type, :string
    belongs_to :users, Rumbl.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content_type,:filesize])
    |> cast_attachments(params, ~w(image video)a )
  end
end
