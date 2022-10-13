defmodule EctoBug.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias EctoBug.Repo

      import Ecto
      import Ecto.Query
      import EctoBug.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EctoBug.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EctoBug.Repo, {:shared, self()})
    end

    :ok
  end
end
