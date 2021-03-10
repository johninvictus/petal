import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
app_port = System.fetch_env!("APP_PORT")
app_hostname = System.fetch_env!("APP_HOSTNAME")
db_user = System.fetch_env!("DB_USER")
db_password = System.fetch_env!("DB_PASSWORD")
db_host = System.fetch_env!("DB_HOST")
app_db = System.fetch_env!("APP_DB")

config :petal, PetalWeb.Endpoint,
  http: [:inet6, port: String.to_integer(app_port)],
  secret_key_base: secret_key_base

config :petal,
  app_port: app_port

config :petal,
  app_hostname: app_hostname


# Configure your database
config :petal, Petal.Repo,
  username: db_user,
  password: db_password,
  database: app_db,
  hostname: db_host,
  pool_size: 10
