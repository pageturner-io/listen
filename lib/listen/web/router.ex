defmodule Listen.Web.Router do
  use Listen.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Listen.Auth.Plug.VerifyCookie
    plug Guardian.Plug.LoadResource
  end

  pipeline :ensure_authentication do
    plug Guardian.Plug.EnsureAuthenticated, handler: Listen.Web.ErrorController
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Listen.Web do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
  end

  scope "/read", Listen.Web do
    pipe_through [:browser, :browser_auth, :ensure_authentication]

    resources "/", ReadingListController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Listen do
  #   pipe_through :api
  # end
end
