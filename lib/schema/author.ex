defmodule EctoBug.Schema.Author do
  use Ecto.Schema

  alias __MODULE__
  import Ecto.Changeset
  import Ecto.Query

  schema "authors" do
    field(:name, :string)
    field(:counter, :integer)

    timestamps()

    has_many(:posts, EctoBug.Schema.Post, defaults: [title: "default"])
  end

  def changeset(schema \\ %Author{}, params) do
    schema
    |> cast(params, [:name, :counter])
    |> validate_required(:name)
  end

  def by_name(name) do
    from(a in Author, where: a.name == ^name)
  end
end
