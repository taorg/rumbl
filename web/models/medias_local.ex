defmodule Rumbl.MediasLocal do
  use Rumbl.Web, :model
  use Arc.Ecto.Schema

  schema "mediaslocal" do
    field :image, Rumbl.ImageArcLocal.Type
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
    |> cast_attachments(params, [:image, :video])    
  end
end
