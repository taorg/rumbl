defmodule Rumbl.PageCommander do
require Logger
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

####################################
# FUSE AUTOCOMPLETE
####################################
def fuse_input_on_keyup(socket, dom_sender) do
    Logger.debug "Dom sender: #{inspect dom_sender}"
    fuse_input = dom_sender["val"]
    case dom_sender |> get_in(["event", "which"]) do
      any_other -> if fuse_input |> String.length > 1 do        
        socket |> execjs(populate_js)
      end
    end
    socket
  end
  def fuse_input_on_autocomplete(socket, dom_sender) do
    Logger.debug "********* on_autocomplete: #{inspect dom_sender}"
    #socket |> execjs(select_customer(fuse_input))
    socket
  end
  defp populate_js do
    """
      $('#fuse-autocomplete-input').fuseautocomplete({          
          data:[{title:"Old Man's War",author:{img:"/images/processing.gif",firstName:"John",lastName:"Scalzi"}},{title:"The Lock Artist",author:{img:"/images/processing.gif",firstName:"Steve",lastName:"Hamilton"}},{title:"HTML5",author:{img:"/images/processing.gif",firstName:"Remy",lastName:"Sharp"}},{title:"Right Ho Jeeves",author:{img:"/images/processing.gif",firstName:"P.D",lastName:"Woodhouse"}},{title:"The Code of the Wooster",author:{img:"/images/processing.gif",firstName:"P.D",lastName:"Woodhouse"}},{title:"Thank You Jeeves",author:{img:"/images/processing.gif",firstName:"P.D",lastName:"Woodhouse"}},{title:"The DaVinci Code",author:{img:"/images/processing.gif",firstName:"Dan",lastName:"Brown"}},{title:"Angels & Demons",author:{img:"/images/processing.gif",firstName:"Dan",lastName:"Brown"}},{title:"The Silmarillion",author:{img:"/images/processing.gif",firstName:"J.R.R",lastName:"Tolkien"}},{title:"Syrup",author:{img:"/images/processing.gif",firstName:"Max",lastName:"Barry"}},{title:"The Lost Symbol",author:{img:"/images/processing.gif",firstName:"Dan",lastName:"Brown"}},{title:"The Book of Lies",author:{img:"/images/processing.gif",firstName:"Brad",lastName:"Meltzer"}},{title:"Lamb",author:{img:"/images/processing.gif",firstName:"Christopher",lastName:"Moore"}},{title:"Fool",author:{img:"/images/processing.gif",firstName:"Christopher",lastName:"Moore"}},{title:"Incompetence",author:{img:"/images/processing.gif",firstName:"Rob",lastName:"Grant"}},{title:"Fat",author:{img:"/images/processing.gif",firstName:"Rob",lastName:"Grant"}},{title:"Colony",author:{img:"/images/processing.gif",firstName:"Rob",lastName:"Grant"}},{title:"Backwards, Red Dwarf",author:{img:"/images/processing.gif",firstName:"Rob",lastName:"Grant"}},{title:"The Grand Design",author:{img:"/images/processing.gif",firstName:"Stephen",lastName:"Hawking"}},{title:"The Book of Samson",author:{img:"/images/processing.gif",firstName:"David",lastName:"Maine"}},{title:"The Preservationist",author:{img:"/images/processing.gif",firstName:"David",lastName:"Maine"}},{title:"Fallen",author:{img:"/images/processing.gif",firstName:"David",lastName:"Maine"}},{title:"Monster 1959",author:{img:"/images/processing.gif",firstName:"David",lastName:"Maine"}}],
          fuseOptions: {
              //id: "title",
              shouldSort: !0,
              threshold: .6,
              location: 0,
              distance: 100,
              maxPatternLength: 32,
              minMatchCharLength: 1,
              keys: [ "title", "firstName" ]
            },             
          dataIdentifierFn: function (fdata_key) {
          var id =  fdata_key.author.lastName;          
          return id;         
          },         
          renderItemFn: function (fdata_key) {
          var image = '<img src="'+ fdata_key.author.img +'" class="right circle"><span>'+ fdata_key.title +'</span>'            
          
          return image;         
          },
          onAutocomplete:function(){ console.log('********ONAUTOCOMPLETE');
                                    console.log($("#fuse-autocomplete-input").data("data-id"));
                                    }
  });
  """
  
  end
end
