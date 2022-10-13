defmodule EctoBug.Repo.Migrations.InitialMigration do
  use Ecto.Migration

  def change do
    create table("authors") do
      add :name,    :string
      add :counter, :integer

      timestamps()
    end

    create index("authors", [:name], unique: true)

    create table("posts") do
      add :title,    :string
      add :content,    :string

      add :author_id, references("authors")

      timestamps()
    end

    create index("posts", [:author_id, :title], unique: true)
  end
end
