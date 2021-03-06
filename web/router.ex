defmodule Rumbl.Router do
  use Rumbl.Web, :router
  alias Rumbl.Endpoint
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]    
  end

  scope "/", Rumbl do
    pipe_through :api

    
    options "/umedia/:uuid", UppuTus, :options
    head "/umedia/:uuid", UppuTus, :head
    get "/umedia/:uuid", UppuTus, :get
    patch "/umedia/:uuid", UppuTus, :patch
    post "/umedia", UppuTus, :post

    options "/dropbox/:uuiid", UppyDropbox, :oauth
    get "/dropbox/auth", UppyDropbox, :gauth
    get "/dropbox/list", UppyDropbox, :glist
    get "/dropbox/thumbnail/:path", UppyDropbox, :gthumbnail
    get "/dropbox/list/:path", UppyDropbox, :glist
    post "/dropbox/get/:path", UppyDropbox, :post_file  

    resources "/media", AjaxArc, only: [:create, :delete]
    resources "/gmap",  GmapsControler, only: [:create]
    resources "/acomplete.json",  AutocompleteControler, only: [:index]
    resources "/gmaps.json",  GmapsControler, only: [:index]
  end
  
  scope "/", Rumbl do
    pipe_through :browser

    get "/connect/:provider", UppyOauth, :get
    get "/connect/:provider/callback", UppyOauth, :callback
    delete "/logout", UppyOauth, :delete

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :edit, :create]
    resources "/images", ImageController  
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rumbl do
  #   pipe_through :api
  # end
end
