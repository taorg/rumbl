defmodule Rumbl.GmapsControler do
  use Rumbl.Web, :controller
  alias ExGoogle.Maps.Api, as: Maps
  @moduledoc false

# google maps reverse geocoding
#IO.inspect "Maps.search(%{latlng: 40.714224,-73.961452})------------------------------------"
#IO.inspect Maps.search(%{latlng: "40.714224,-73.961452"})
# Advanced parameters
#IO.inspect "Maps.search(%{latlng: 40.714224,-73.961452, location_type: ROOFTOP|RANGE_INTERPOLATED|GEOMETRIC_CENTER, result_type: street_address})------------------------------------"
#IO.inspect Maps.search(%{latlng: "40.714224,-73.961452", location_type: "ROOFTOP|RANGE_INTERPOLATED|GEOMETRIC_CENTER", result_type: "street_address"})

# google maps geocoding
def create(conn, _params) do
    IO.inspect "Maps.search(%{address: 1600 Amphitheatre Parkway, Mountain View, CA})------------------------------------"

    map_address =  Maps.search(%{address: " Calle conde de elda alhama"})
        |>IO.inspect 
         #|>elem(1)
         #|>List.first()

    IO.inspect map_address["formatted_address"]
    IO.inspect map_address["geometry"]["location"]["lat"]
    IO.inspect map_address["geometry"]["location"]["lng"]

end
end
