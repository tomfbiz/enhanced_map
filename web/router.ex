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
  end

  scope "/", EnhancedMap do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/" do
       addict :routes
  end
  # Other scopes may use custom stacks.
  # scope "/api", EnhancedMap do
  #   pipe_through :api
  # end
end
