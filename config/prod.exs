import Config

# Database configuration
config :real_time_chat_app, RealTimeChatApp.Repo,
  username: "postgres",
  password: "root",
  hostname: "localhost",
  database: "real_time_chat_app_prod",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# The secret key base is used to sign/encrypt cookies and other secrets.
# A default value is used in config/dev.exs and config/test.exs but you
# want to use a different value for prod and you most likely don't want
# to check this value into version control.
secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :real_time_chat_app, RealTimeChatAppWeb.Endpoint,
  http: [
    ip: {0, 0, 0, 0, 0, 0, 0, 0},
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  secret_key_base: secret_key_base

# Configures the endpoint
config :real_time_chat_app, RealTimeChatAppWeb.Endpoint,
  url: [host: System.get_env("PHX_HOST") || "example.com", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
import_config "prod.secret.exs"
