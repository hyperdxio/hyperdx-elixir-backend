# HyperDX elixir backend
Elixir logging backend that sends your logs to HyperDX using the https bulk input 

## Installation

The package can be installed by adding `hyperdx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hyperdx, "~> 0.1.0"}
  ]
end
```

## Usage
If you do not already have a HyperDX account, please signup for one and obtain the following details:
1. Listener host
2. Data shipping token

Once you have these, you are all set to integrate your Elixir app with hyperdx.

```elixir
# config/releases.exs
config :logger, 
  level: :info, 
  backends: [:console, {hyperdx.Backend, :hyperdx}]

config :logger, 
  hyperdx: [
    token: System.get_env("HYPERDX_API_KEY")
  ]
```

That's it. You should now be able to see your app logs by heading over to [HyperDX](https://hyperdx.io)!

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hyperdx](https://hexdocs.pm/hyperdx).
