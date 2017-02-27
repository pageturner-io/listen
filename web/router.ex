defmodule Web.Router do
  use Web.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Web.Auth.Plug.VerifyCookie
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: Web.ErrorController
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Web do
    pipe_through [:browser]

    get "/", PageController, :index
  end

  scope "/articles", Web do
    pipe_through [:browser, :browser_auth]

    resources "/", ArticleController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Web do
  #   pipe_through :api
  # end
end
