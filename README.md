# EctoBug

PoC for replicating Ecto upsert bug.

To replicate the bug:

1. launch mysql and keep it running:
    ``` bash
    docker compose up
    ```  

2. execute tests:
    ``` bash
    mix deps.get && mix compile
    mix ecto.create
    mix ecto.migrate

    iex -S mix run -e "EctoBug.replicate"
    ```
    
    **OR**

    ``` bash
    mix deps.get && mix test
    ```

Expected result: the ID of the returned updated author is not `nil`.

Actual result:

``` elixir
%EctoBug.Schema.Author{
  __meta__: #Ecto.Schema.Metadata<:loaded, "authors">,
  counter: nil,
  id: nil,
  inserted_at: ~N[2022-10-13 09:28:11],
  name: "author1",
  posts: #Ecto.Association.NotLoaded<association :posts is not loaded>,
  updated_at: ~N[2022-10-13 09:28:11]
}
```

## Working case

If we put a `:timer.sleep` after each write, the ID of the updated record is not `nil`:
``` elixir
%EctoBug.Schema.Author{
  __meta__: #Ecto.Schema.Metadata<:loaded, "authors">,
  counter: nil,
  id: 1,
  inserted_at: ~N[2022-10-13 09:28:11],
  name: "author1",
  posts: #Ecto.Association.NotLoaded<association :posts is not loaded>,
  updated_at: ~N[2022-10-13 09:28:11]
}
```
