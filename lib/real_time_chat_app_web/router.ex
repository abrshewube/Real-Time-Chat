defmodule RealTimeChatAppWeb.Router do
  use RealTimeChatAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RealTimeChatAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RealTimeChatAppWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_auth do
    plug RealTimeChatAppWeb.Auth.RequireUser
  end

  # Public routes
  scope "/", RealTimeChatAppWeb do
    pipe_through :browser

    live "/", HomeLive, :index, as: :home
    post "/login", SessionController, :create
    post "/register", SessionController, :register
    get "/logout", SessionController, :delete
    delete "/logout", SessionController, :delete
  end

  # Protected routes
  scope "/", RealTimeChatAppWeb do
    pipe_through [:browser, :require_auth]

    live "/chat", ChatLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RealTimeChatAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:real_time_chat_app, :dev_routes, false) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RealTimeChatAppWeb.Telemetry
    end
  end
end
