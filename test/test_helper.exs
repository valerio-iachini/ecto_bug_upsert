ExUnit.start()
EctoBug.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(EctoBug.Repo, :manual)
