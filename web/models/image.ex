defmodule Rumbl.Image do
  use Rumbl.Web, :model
  use Arc.Ecto.Schema

  schema "images" do
    field :image, Rumbl.ImageUploader.Type
    belongs_to :users, Rumbl.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:image])
    |> cast_attachments(params, [:image])
    |> validate_required([:image])
  end
end
