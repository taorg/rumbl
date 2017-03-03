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

  pipeline :pharc do
    plug :accepts, ["json"]    
  end

  scope "/pharc", Rumbl do
    pipe_through :pharc
    resources "/media", AjaxArc, only: [:create, :delete]
    resources "/gmap",  GmapsControler, only: [:create]
    resources "/acomplete",  AutocompleteControler, only: [:index]
  end
  
  scope "/", Rumbl do
    pipe_through :browser
    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :edit, :create]
    resources "/images", ImageController  
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rumbl do
  #   pipe_through :api
  # end
end
