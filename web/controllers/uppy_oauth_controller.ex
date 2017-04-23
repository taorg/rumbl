defmodule Rumbl.UppyOauth do
  use Rumbl.Web, :controller  
    require Logger
  

  def get(conn, %{"provider" => provider}) do
    IO.puts "GET----------------------"
    redirect conn, external: authorize_url!(provider)
  end

   def callback(conn, %{"provider" => provider, "code" => code}) do
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
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/")
  end
########
#DROPBOX
########
  defp authorize_url!("dropbox"),   do: Dropbox.authorize_url!
  defp get_token!("dropbox", code),   do: Dropbox.get_token!(code: code) 
  defp get_user!("dropbox", client) do
    {:ok, %{body: user}} = OAuth2.Client.get!(client, "https://www.dropboxapis.com/plus/v1/people/me/openIdConnect")
    %{name: user["name"], avatar: user["picture"]}
  end
########
#GOOGLE
########
  defp authorize_url!("google"),   do: Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email")
  defp get_token!("google", code),   do: Google.get_token!(code: code) 
  defp get_user!("google", client) do
    {:ok, %{body: user}} = OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    %{name: user["name"], avatar: user["picture"]}
  end
########
#DEFAULT
########
  defp authorize_url!(_), do: raise "No matching provider available"
  defp get_token!(_, _), do: raise "No matching provider available"
end