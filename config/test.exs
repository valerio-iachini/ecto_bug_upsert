import Config

config :logger,
  level: :debug

config :ecto_bug, EctoBug.Repo, pool: Ecto.Adapters.SQL.Sandbox
