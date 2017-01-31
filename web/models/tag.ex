defmodule Rumbl.Tag do
  use Rumbl.Web, :model

  schema "tags" do
	field :name, :string, null: false
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:tag])
	    |> validate_required([:tag])
  end
end