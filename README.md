# BskySimple
Simple Bluesky client


## Example

```
{:ok, session} = BskySimple.create_session(@identifier, @password)
{:ok, result} = BskySimple.get_profile(session, @identifier)

BskySimple.delete_session(session)
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bsky_simple` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bsky_simple, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/bsky_simple>.

