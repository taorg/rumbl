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
####################################
# GMAP SELECT
####################################
    def gaddress_select_input(socket, dom_sender) do
        map_search =  Maps.search(%{address: dom_sender["val"]})
        map_address_map = gmaps_select (map_search)

        socket
        |> update!(:html, set: map_address_map,  on: "#gmap-address-select")
        # $('#gmap-address-select').prevAll('input.select-dropdown').val()
        #$('#gmap-address-select').prevAll('input.select-dropdown').trigger('open')
        _= socket
        |>execjs("$('#gmap-address-select').material_select();")
        socket
    end


    defp gmaps_select (map_search) do
        IO.inspect map_search
        case map_search do
            {:ok, %{"results" => [], "status" => "ZERO_RESULTS"}}->
                                "ZERO_RESULTS"
                                map_address_map = []
            {:error, error_map, error_code}->
                                error_map["error_message"]
                                map_address_map = []
            {:ok, map_address_struct}->
                                map_address_map = Enum.map(map_address_struct, fn(x)-> gmaps_flat(x)  end)
        end

        option_map = Enum.map(map_address_map, fn(x)-> "<option value='#{x}'>#{x}</option>"  end)

        case Enum.count(option_map) do
          0-> "<option value=''></option>"
          _->Enum.reduce(option_map,fn(x, acc) -> x<>acc end)
        end

    end

    defp gmaps_flat(x) do
         x["formatted_address"]
    end

    def gmap_address_select_changed(socket, dom_sender) do
        #IO.inspect dom_sender
        ""
        _= socket
    end


end
