import Config

config :ecto_bug, ecto_repos: [EctoBug.Repo]

config :ecto_bug, EctoBug.Repo,
  database: "ecto_bug",
  hostname: "localhost",
  username: "root",
  password: "root"


import_config "#{Mix.env()}.exs"
