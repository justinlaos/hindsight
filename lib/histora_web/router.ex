defmodule HistoraWeb.Router do
  use HistoraWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HistoraWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug HistoraWeb.EnsureRolePlug, :admin
  end

  pipeline :authorized do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler

  end

  pipeline :scope_resources do
    plug HistoraWeb.ScopeOrganization
  end

  pipeline :activeUser do
    plug HistoraWeb.EnsureUserActivePlug,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  # Open Routes
    scope "/", HistoraWeb do
    pipe_through [:browser]

    get "/", MarketingController, :index
  end

   # Authorized Active Routes
   scope "/", HistoraWeb do
    pipe_through [:browser, :authorized, :activeUser, :scope_resources]

    get "/home", OrganizationController, :home
    resources "/records", RecordController
  end

  # Authorized Active Admin Routes
  scope "/admin", HistoraWeb do
    pipe_through [:browser, :admin, :authorized, :activeUser]

    resources "/invitations", InvitationController, only: [:new, :create, :show]

    post "/users/:id/archive", Admin.UserController, :archive
    post "/users/:id/unarchive", Admin.UserController, :unarchive

  end

  # Authorized Admin Active-Agnostic Routes
  scope "/admin", HistoraWeb do
    pipe_through [:browser, :admin, :authorized]

    post "/create_customer_portal_session/:id", Admin.BillingController, :create_customer_portal_session
  end

  # Authorization Routes
  scope "/", Pow.Phoenix, as: "pow" do
    pipe_through [:browser, :authorized, :activeUser]

    resources "/registration", RegistrationController, singleton: true, only: [:edit, :update, :delete]
  end

  # Open Webhook for stripe
  scope "/stripe/webhooks" do
    post "/", WebhooksController, :webhooks
  end

   # Pow Routes
   scope "/" do
    pipe_through [:browser]

    pow_session_routes()
    pow_extension_routes()
  end

  # Other scopes may use custom stacks.
  # scope "/api", HistoraWeb do
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

      live_dashboard "/dashboard", metrics: HistoraWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
