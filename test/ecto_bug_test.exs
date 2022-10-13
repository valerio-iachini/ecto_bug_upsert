defmodule EctoBugTest do
  use EctoBug.RepoCase

  alias EctoBug.Schema.Author
  alias EctoBug.Schema.Post

  describe "upsert" do
    test "when the contents of posts have been changed, it should return the IDs of the updated posts" do
      {:ok, author} = %{name: "authorz"} |> Author.changeset() |> Repo.insert()

      {:ok, _} =
        %{title: "title1", content: "content", author: author, author_id: author.id}
        |> Post.changeset()
        |> Repo.insert()

      {:ok, _} =
        %{title: "title2", content: "content", author: author, author_id: author.id}
        |> Post.changeset()
        |> Repo.insert()

      [
        %{title: "title1", content: "new", author_id: author.id},
        %{title: "title2", content: "new2", author_id: author.id}
      ]
      |> Enum.each(fn changeset ->
        {:ok, updated_post} =
          changeset
          |> Post.changeset()
          |> Repo.insert(on_conflict: {:replace_all_except, [:id]})

        assert updated_post.id != nil
      end)
    end

    test "when the counters of authors have been changed, it should return the IDs of the updated authors" do
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

      # upsert authors
      [
        %{name: "author1", counter: 2},
        %{name: "author2", counter: 2}
      ]
      |> Enum.each(fn changeset ->
        {:ok, updated_author} =
          changeset
          |> Author.changeset()
          |> Repo.insert(on_conflict: {:replace_all_except, [:id]})

        assert updated_author.id != nil
      end)
    end
  end

  describe "no sleep" do
    test "when no changes have been made, it should return the IDs of the authors" do
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

      # upsert authors
      [
        %{name: "author1", counter: 0},
        %{name: "author2", counter: 0}
      ]
      |> Enum.each(fn changeset ->
        {:ok, updated_author} =
          changeset
          |> Author.changeset()
          |> Repo.insert(on_conflict: {:replace_all_except, [:id]})

        author_id =
          case updated_author.name do
            "author1" -> author_1.id
            "author2" -> author_2.id
          end

        assert updated_author.id == author_id
      end)
    end
  end

  describe "sleep" do
    test "when no changes have been made, it should return the IDs of the authors" do
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

      :timer.sleep(500)
      # upsert authors
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

        author_id =
          case updated_author.name do
            "author1" -> author_1.id
            "author2" -> author_2.id
          end

        assert updated_author.id == author_id
      end)
    end
  end
end
