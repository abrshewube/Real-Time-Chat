import Config

# Configure your database for tests
config :real_time_chat_app, RealTimeChatApp.Repo,
  username: "postgres",
  password: "root",
  hostname: "localhost",
  database: "real_time_chat_app_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :real_time_chat_app, RealTimeChatAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh mailer in test environment
config :real_time_chat_app, RealTimeChatAppWeb.Mailer, adapter: Swoosh.Adapters.Test

# We don't need a secret key base for tests, but Phoenix requires it
config :real_time_chat_app, RealTimeChatAppWeb.Endpoint,
  secret_key_base: "test-secret-key-base-for-testing-purposes-only-must-be-at-least-64-bytes-long-for-validation"
