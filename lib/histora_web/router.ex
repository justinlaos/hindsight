defmodule HistoraWeb.Router do
  use HistoraWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowInvitation]

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
    plug HistoraWeb.APIAuthPlug, otp_app: :histora
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: HistoraWeb.APIAuthErrorHandler
  end

  pipeline :admin do
    plug HistoraWeb.EnsureRolePlug, :admin
  end

  pipeline :completed_welcome do
    plug HistoraWeb.EnsureUserWelcomeCompletePlug
  end

  pipeline :is_active do
    plug HistoraWeb.EnsureOrganizationIsActivePlug
  end

  pipeline :has_trial_expired do
    plug HistoraWeb.CheckIfTrialHasExpiredPlug
  end

  pipeline :authorized do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :scope_resources do
    plug HistoraWeb.ScopeOrganization
    plug HistoraWeb.AddDecisionChangesetPlug
    plug HistoraWeb.AddScopesPlug
    plug HistoraWeb.AddUsersPlug
    plug HistoraWeb.AddTagsPlug
  end

  pipeline :activeUser do
    plug HistoraWeb.EnsureUserActivePlug,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  # Open Routes
    scope "/", HistoraWeb do
    pipe_through [:browser]

    get "/", MarketingController, :index
    get "/signup", SignupController, :signup
    post "/create_organization_trial", SignupController, :create_organization_trial
    get "/privacy_policy", PolicyController, :privacy_policy
    get "/terms_and_conditions", PolicyController, :terms_and_conditions
  end

  # Authorized Active Routes
  scope "/", HistoraWeb do
    pipe_through [:browser, :authorized, :completed_welcome, :activeUser, :scope_resources, :is_active, :has_trial_expired]

    post "/results", SearchController, :results
    get "/results", SearchController, :results
    resources "/decisions", DecisionController
    resources "/scopes", ScopeController
    resources "/reflections", ReflectionController
    get "/past_due", ReflectionController, :past_due
    get "/all_reflection_decsions", ReflectionController, :all_reflection_decsions
    resources "/drafts", DraftController
    post "/draft_vote", Draft_voteController, :create
    resources "/draftoptions", Draft_optionController
    post "/draft/convert", DraftController, :convert
    resources "/tags", TagController
    resources "/users", UserController
    post "/tag/favorite", TagController, :favorite
    post "/tag/unfavorite", TagController, :unfavorite
    post "/user/favorite", UserController, :favorite
    post "/user/unfavorite", UserController, :unfavorite
  end

  scope "/", HistoraWeb do
    pipe_through [:browser, :authorized, :activeUser]

    get "welcome/getting-started", WelcomeController, :getting_started
    get "welcome/admin", WelcomeController, :admin
    get "welcome/complete_welcome", WelcomeController, :complete_welcome
    get "welcome/complete_admin", WelcomeController, :complete_admin
    get "/paused", InactiveController, :paused
    get "/trial_expired", InactiveController, :trial_expired
  end

  # Authorized Active Admin Routes
  scope "/admin", HistoraWeb do
    pipe_through [:browser, :admin, :authorized, :activeUser, :scope_resources, :is_active, :has_trial_expired]

    get "/settings/integrations", Admin.SettingsController, :integrations
    get "/settings/tags", Admin.SettingsController, :tags
  end

  # Authorized Admin Active-Agnostic Routes
  scope "/admin", HistoraWeb do
    pipe_through [:browser, :admin, :authorized, :scope_resources]

    post "/create_customer_portal_session/:id", Admin.SettingsController, :create_customer_portal_session
    get "/settings/convert_trial", Admin.SettingsController, :convert_trial

    get "/settings/organization", Admin.SettingsController, :organization
    put "/settings/organization/:id", Admin.SettingsController, :update
    post "/settings/invitations", Admin.InvitationController, :create
    post "/users/:id/cancel_invite", Admin.UserController, :cancel_invite
    post "/users/:id/archive", Admin.UserController, :archive
    post "/users/:id/unarchive", Admin.UserController, :unarchive

    post "/select_plan", Admin.SettingsController, :select_plan
  end

  # Authorization Routes
  scope "/", Pow.Phoenix, as: "pow" do
    pipe_through [:browser, :authorized, :activeUser, :scope_resources, :is_active, :has_trial_expired]

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

  scope "/api/v1", HistoraWeb.API.V1, as: :api_v1 do
    pipe_through :api

    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api/v1", HistoraWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    post "/decision", DecisionController, :create

    # Your protected API endpoints here
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
