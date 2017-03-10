defmodule Listen.Router do
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
    plug Guardian.Plug.EnsureAuthenticated, handler: Listen.ErrorController
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Listen do
    pipe_through [:browser]

    get "/", PageController, :index
  end

  scope "/articles", Listen do
    pipe_through [:browser, :browser_auth]

    resources "/", ArticleController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Listen do
  #   pipe_through :api
  # end
end
