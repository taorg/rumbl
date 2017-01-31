defmodule Rumbl.UserView do
  use Rumbl.Web, :view
  alias Rumbl.User

  def first_name(user) do
    %User{name: name} = user
    cond do
      is_nil(name)                -> name
      String.contains?(name," ")  ->
          name
            |> String.split(" ")
            |> Enum.at(0) 
       true ->name    
    end
  end
  
  def surname(user) do
    %User{name: name} = user
    cond do
      is_nil(name)                -> name
      String.contains?(name," ")  ->
          name
            |> String.split(" ")
            |> Enum.at(1) 
       true ->name    
    end
  end

end
