# HyperDX elixir backend (BETA)
Elixir logging backend that sends your logs to HyperDX using the https bulk input 

## Installation

The package can be installed by adding `hyperdx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hyperdx, "~> 0.1.5"}
  ]
end
```

## Configure Logger
Add the following to your `config.exs` file:

```elixir
# config/releases.exs

config :logger,
  level: :info,
  backends: [:console, {Hyperdx.Backend, :hyperdx}],
  hyperdx: [
    service: System.get_env("OTEL_SERVICE_NAME"),
    token: System.get_env("HYPERDX_API_KEY")
  ]
```

### Configure Environment Variables

Afterwards you'll need to configure the following environment variables in your
shell to ship telemetry to HyperDX:

```sh
export HYPERDX_API_KEY='<YOUR_HYPERDX_API_KEY_HERE>' \
OTEL_SERVICE_NAME='<NAME_OF_YOUR_APP_OR_SERVICE>'
```

That's it. You should now be able to see your app logs by heading over to [HyperDX](https://hyperdx.io)!

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hyperdx](https://hexdocs.pm/hyperdx).
