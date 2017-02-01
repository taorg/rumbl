defmodule Rumbl.Tagmaps do
  use Rumbl.Web, :model

  schema "tagmaps" do
	field :tag_id, :integer, null: false
  field :tag_sources_id, :integer
  field :user_id, :integer
  has_many :tags, Rumbl.Tag
  end

  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:tag_id])
	    |> validate_required([:tag_id])
  end
end