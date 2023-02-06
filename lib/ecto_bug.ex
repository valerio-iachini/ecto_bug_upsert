defmodule EctoBug do
  @moduledoc """
  Documentation for `EctoBug`.
  """

  alias EctoBug.Repo
  alias EctoBug.Schema.Author
  alias EctoBug.Schema.Post

  def replicate(variation \\ :no_change_no_sleep) do
    Repo.start_link()
    clear_db()
    init_db()
    do_replicate(variation)
  end

  # it doesn't work
  def do_replicate(:no_change_no_sleep) do
    [
      %{name: "author1", counter: 0},
      %{name: "author2", counter: 0}
    ]
    |> Enum.each(fn changeset ->
      {:ok, updated_author} =
        changeset
        |> Author.changeset()
        |> Repo.insert(on_conflict: {:replace_all_except, [:id]})

      IO.inspect(updated_author.id, label: "UPDATED ID")
    end)
  end

  # works
  def do_replicate(:no_change_sleep) do
    :timer.sleep(500)

    [
      %{name: "author1", counter: 0},
      %{name: "author2", counter: 0}
    ]
    |> Enum.each(fn changeset ->
      :timer.sleep(500)

      {:ok, updated_author} =
        changeset
        |> Author.changeset()
        |> Repo.insert(on_conflict: {:replace_all_except, [:id]})

      IO.inspect(updated_author.id, label: "UPDATED ID")
    end)
  end

  # works
  def do_replicate(:replace_all) do
    Repo.delete_all(Post)

    [
      %{name: "author1", counter: 0},
      %{name: "author2", counter: 0}
    ]
    |> Enum.each(fn changeset ->
      {:ok, updated_author} =
        changeset
        |> Author.changeset()
        |> Repo.insert(on_conflict: :replace_all)

      IO.inspect(updated_author.id, label: "UPDATED ID")
    end)
  end

  defp clear_db() do
    Repo.delete_all(Post)
    Repo.delete_all(Author)
  end

  defp init_db() do
    # author 1
    {:ok, author_1} = %{name: "author1", counter: 0} |> Author.changeset() |> Repo.insert()

    {:ok, _} =
      %{title: "title1", content: "content", author: author_1, author_id: author_1.id}
      |> Post.changeset()
      |> Repo.insert()

    {:ok, _} =
      %{title: "title2", content: "content", author: author_1, author_id: author_1.id}
      |> Post.changeset()
      |> Repo.insert()

    # author 2
    {:ok, author_2} = %{name: "author2", counter: 0} |> Author.changeset() |> Repo.insert()

    {:ok, _} =
      %{title: "title1", content: "content", author: author_2, author_id: author_2.id}
      |> Post.changeset()
      |> Repo.insert()

    {:ok, _} =
      %{title: "title2", content: "content", author: author_2, author_id: author_2.id}
      |> Post.changeset()
      |> Repo.insert()
  end
end
