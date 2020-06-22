defmodule SprinklerWeb.Router do
  use SprinklerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SprinklerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SprinklerWeb do
    pipe_through :browser

    live "/", PageLive, :index

    scope "/admin" do
      live "/devices", DeviceLive.Index, :index
      live "/devices/new", DeviceLive.Index, :new
      live "/devices/:id/edit", DeviceLive.Index, :edit

      live "/devices/:id", DeviceLive.Show, :show
      live "/devices/:id/show/edit", DeviceLive.Show, :edit
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SprinklerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SprinklerWeb.Telemetry
    end
  end
end
