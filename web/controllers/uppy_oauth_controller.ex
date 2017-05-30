defmodule Rumbl.UppyOauth do
  use Rumbl.Web, :controller  
    require Logger
  

  def get(conn, %{"provider" => provider, "state" =>state}) do
    IO.puts "GET--------UppyOauth--------------"
    
    redirect conn, external: authorize_url!([provider, state: state])
  end

   def callback(conn, %{"provider" => provider, "code" => code}) do
    IO.puts "CALLBACK--------UppyOauth--------------"
        
    # Exchange an auth code for an access token
    client = get_token!(provider, code)

    # Request the user's data with the access token
    user = get_user!(provider, client)

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.    
    IO.puts "CALLBACK--------UppyOauth--------------"
    IO.puts "PROVIDER #{provider}"
    IO.puts "TOKEN #{client.token.access_token}"
    conn
    |> put_session(:current_user, user)
    |> put_session(provider, client.token.access_token)
    |> redirect(to: "/new")
  end
########
#DROPBOX
########
  defp authorize_url!(["dropbox" | params]) do
      Dropbox.authorize_url!(params)
  end
  defp get_token!("dropbox", code),   do: Dropbox.get_token!(code: code) 
  defp get_user!("dropbox", client) do
    %OAuth2.Response{body: body}  = OAuth2.Client.get!(client, "https://api.dropboxapi.com/1/account/info")
    %{name: body["email"], avatar: body["display_name"]}
  end
########
#GOOGLE
########
  defp authorize_url!(["google" | params]),   do: Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email")
  defp get_token!("google", code),   do: Google.get_token!(code: code) 
  defp get_user!("google", client) do
    {:ok, %{body: user}} = OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    %{name: user["email"], avatar: user["display_name"]}
  end
########
#DEFAULT
########
  defp authorize_url!(_), do: raise "No matching provider available"
  defp get_token!(_, _), do: raise "No matching provider available"
end