defmodule Rumbl.Instalation do
  use Rumbl.Web, :model

  schema "instalations" do
	field :city,    :string, size: 40
	field :temp_lo, :integer
	field :temp_hi, :integer
	field :prcp,    :float

    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:city, :temp_lo, :temp_hi, :prcp])
    |> validate_length(:city, min: 1, max: 40)
    |> validate_number(:prcp, greater_than_or_equal_to: 0)
  end
end