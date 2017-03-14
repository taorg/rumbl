defmodule Rumbl.GmapsControler do
  use Rumbl.Web, :controller
  alias ExGoogle.Maps.Api, as: Maps
  @moduledoc false

# google maps geocoding
    def index(conn, _params) do        
        
        IO.inspect _params["address"]

        map_address =  Maps.search(%{address: _params["address"]})
        map_address_data =  gmaps_select(map_address,_params["address"])
        trailed_addresses = String.replace_trailing(map_address_data,",\n","")
        |>IO.inspect
            #|>elem(1)
            #|>List.first()

        send_resp(conn, 200, "{\"status\":true,\"error\":null,\"data\":{\"address\":[#{trailed_addresses}]}}")
        
    end

    defp gmaps_select(map_search,address_param) do
        #IO.inspect map_search
        case map_search do
            {:ok, %{"results" => [], "status" => "ZERO_RESULTS"}}->
                                "ZERO_RESULTS"
                                map_address_map = []
            {:error, error_map, error_code}->
                                error_map["error_message"]
                                map_address_map = []
            {:ok, map_address_struct}->
                                populate_json(map_address_struct,address_param)
        end

    end

    defp gmaps_flat(x) do
         x["formatted_address"]
    end
    defp populate_json(map_address_struct,address_param) do
        EEx.eval_string( """
            <%= for geolocation <- geolocations do %>                
                 {  "param":"<%= param %>",
                    "address":"<%= geolocation["formatted_address"] %>",
                    "lat":"<%= geolocation["geometry"]["location"]["lat"] %>",
                    "lng":"<%= geolocation["geometry"]["location"]["lng"] %>" } ,<% end %>
                    """, [geolocations: map_address_struct,param: address_param]) 

    end


end
