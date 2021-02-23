defmodule ToastMeWeb.Router do
  use ToastMeWeb, :router

  alias ToastMeWeb.AuthenticatePlug
  alias ToastMeWeb.EnsureProfilePlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ToastMeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_authenticate do
    plug :browser
    plug AuthenticatePlug
  end

  pipeline :browser_authenticate_profile do
    plug :browser_authenticate
    plug EnsureProfilePlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ToastMeWeb do
    pipe_through :browser

    get "/", PagesController, :home
    get "/delete-data", PagesController, :delete
    get "/privacy-policy", PagesController, :privacy

    get "/auth/logout", AuthController, :logout
    get "/auth/:provider", AuthController, :request
    get "/auth/:provider/callback", AuthController, :callback
  end

  scope "/", ToastMeWeb do
    pipe_through :browser_authenticate
    live "/setup", SetupLive, :index
  end

  scope "/", ToastMeWeb do
    pipe_through :browser_authenticate_profile
    live "/match", MatchLive, :index
    live "/roast", RoastLive, :index
  end

  # Development only endpoints
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ToastMeWeb.Telemetry
    end

    scope "/", ToastMeWeb do
      pipe_through :browser
      get "/dangerous/:user_id", AuthController, :dangerous
    end
  end
end
