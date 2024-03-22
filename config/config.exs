# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :hindsight,
  ecto_repos: [Hindsight.Repo]

# Configures the endpoint
config :hindsight, HindsightWeb.Endpoint,
  url: [host: System.get_env("RENDER_EXTERNAL_HOSTNAME") || "localhost", port: 80],
  secret_key_base: "z34502VtAmc07Oc0Pq4JgEqkF+o3yiYSVWIjZXLJq5qhZSIeTwIrXbRDOrF7rsg7",
  render_errors: [view: HindsightWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hindsight.PubSub,
  live_view: [signing_salt: "T7ClLDU5"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
# config :hindsight, Hindsight.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# Use and set Tailwild
config :tailwind,
  version: "3.0.24",
  default: [
    args: ~w(
    --config=tailwind.config.js
    --input=css/app.css
    --output=../priv/static/assets/app.css
  ),
    cd: Path.expand("../assets", __DIR__)
  ]

# STRIPE CONFIG
config :stripity_stripe,
  api_key: System.get_env("STRIPE_SECRET_API")

# POW USER AUTH
config :hindsight, :pow,
  user: Hindsight.Users.User,
  repo: Hindsight.Repo,
  extensions: [ PowResetPassword, PowInvitation ],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_module: HindsightWeb,
  mailer_backend: HindsightWeb.Pow.Mailer,
  web_mailer_module: HindsightWeb,
  routes_backend: HindsightWeb.Pow.Routes

# POW EMAIL SENDER
config :hindsight, HindsightWeb.Pow.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SEND_GRID_API")

# BAMBOO EMAIL SENDER
config :hindsight, Hindsight.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SEND_GRID_API")

# CRON JOB SCHEDULER
config :hindsight, Hindsight.Scheduler,
  jobs: [
   run_weekly_roundup: [
    schedule: "@weekly",
    task: {Hindsight.Job.Organizations, :run_weekly_roundup, []}
   ],
   run_daily_scheduled_reflections: [
    schedule: "@daily",
    task: {Hindsight.Job.Organizations, :run_daily_scheduled_reflections, []}
   ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
