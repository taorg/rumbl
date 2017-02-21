defmodule Rumbl.Tag do
  use Rumbl.Web, :model

  schema "tags" do
	field :tag, :string, null: false
  belongs_to :tagmaps, Rumbl.Tagmaps
  timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:tag])
	  |> validate_required([:tag])
  end
end