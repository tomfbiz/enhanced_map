defmodule EnhancedMap.Router do
  use EnhancedMap.Web, :router
  use Addict.RoutesHelper

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
 end

  pipeline :api do
    plug :accepts, ["json"]  
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/edit", EnhancedMap, as: :edit do
    pipe_through :browser # Use the default browser stack
    resources "/map", MapController do
      resources "/markers", MarkerController, except: [:index]
    end
    get "/", PageController, :index
  end

  scope "/api", EnhancedMap do
    pipe_through :api
    resources "/map", MapController, only: [:update] do
      resources "/markers", APIMarkerController, only: [:update]
    end
  end
  
  scope "/", EnhancedMap do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
    resources "/map", ReadonlyMapController, only: [:show]
  end

  scope "/" do
       addict :routes
  end
  # Other scopes may use custom stacks.
  # scope "/api", EnhancedMap do
  #   pipe_through :api
  # end
end
