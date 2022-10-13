defmodule EctoBug.Schema.Post do
  use Ecto.Schema

  alias __MODULE__
  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    field(:content, :string)

    timestamps()

    belongs_to(:author, EctoBug.Schema.Author)
  end

  def changeset(schema \\ %Post{}, params) do
    schema
    |> cast(params, [:author_id, :title, :content])
    |> validate_required([:author_id, :title, :content])
  end
end
