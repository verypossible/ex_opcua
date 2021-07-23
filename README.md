# ExOpcua

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_opcua` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_opcua, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_opcua](https://hexdocs.pm/ex_opcua).

## Testing

```
mix test
```

### Integration Testing

Integration testing relies on an externally running OPCUA Simulation Server

An example server can be found [here](https://www.prosysopc.com/products/opc-ua-simulation-server/)

Modules marked as `:integration` will be run, and test cases need to update the tests

ex:

```
opts = [ip: "Daniels-MacBook-Pro.local", port: 53530]
```

```
 mix test --include integration
```
