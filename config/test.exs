import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex_shell, ExShellWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "IJOg7jRLpAzHsAMKQjzgZBVTi1FLX+0KwwUqlvHOLgpnokYbzkTRbF8Qd+Vi+zXQ",
  server: false

# In test we don't send emails.
config :ex_shell, ExShell.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
