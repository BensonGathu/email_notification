# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :email_notification,
  ecto_repos: [EmailNotification.Repo]

# Configures the endpoint
config :email_notification, EmailNotificationWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: EmailNotificationWeb.ErrorHTML, json: EmailNotificationWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: EmailNotification.PubSub,
  live_view: [signing_salt: "QZrvbEDg"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.

config :email_notification, EmailNotification.Mailer,
adapter: Swoosh.Adapters.SMTP,
relay: "in-v3.mailjet.com",
username: "c118aadad27b172b03ced6cbb7811aea",
password: "cab17312e7a41cbc2b6ec65f80d4c1f3",
tls: :if_available,
ssl: false,
port: 25


# Configure Bamboo email sender
# config :email_notification, EmailNotification.Mailer,
#   adapter: Bamboo.SMTPAdapter,
#   server: "in-v3.mailjet.com",
#   port: 587,
#   username: "",
#   password: "ohmawjghuhuzpxji",
#   tls: :always,
#   retries: 2

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
