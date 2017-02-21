defmodule Rumbl.PageCommander do
use Drab.Commander,modules: [Drab.Query]
alias ExGoogle.Maps.Api, as: Maps
    def gaddress_autocomplete_input_changed(socket, dom_sender) do
        map_search =  Maps.search(%{address: dom_sender["val"]})
        label = gmaps_ws (map_search)
    label = gmaps_ws (map_search)
    js_code = "$('#gaddress-autocomplete-input').autocomplete({data: {'#{label}': null},limit: 10,});"
    IO.inspect js_code
        _= socket
            |>execjs(js_code)
        socket
    end

    def gaddress_changed_input(socket, dom_sender) do
IO.inspect "-----dom_sender-------"
IO.inspect dom_sender
        map_search =  Maps.search(%{address: dom_sender["val"]})
        label = gmaps_ws (map_search)

        socket
        |> update!(:text, set: String.upcase(label),  on: "#google-address-label")
    end

    defp gmaps_ws (map_search) do
        case map_search do
            {:ok, %{"results" => [], "status" => "ZERO_RESULTS"}}->
                                "ZERO_RESULTS"
                                ""
            {:error, error_map, error_code}->
                                error_map["error_message"]
                                ""
            {:ok, map_address_struct}->
                                map_address = List.first(map_address_struct)
                                map_address["formatted_address"]
        end

    end


end
