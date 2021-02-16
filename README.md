# ExUssdSimulator
### The development UI for [ExUssd](https://github.com/beamkenya/ex_ussd)

![](screencast.gif)

## Installation

Add the `:ex_ussd_simulator` package to your `deps` list in `mix.exs`:

```elixir
defp deps do
  ...
  {:ex_ussd_simulator, "~> 0.1.0", only: :dev}
  ...
end
```

You need to set the `callback_url` of the simulator to your `ExUssd` endpoint:

```elixir
config :ex_ussd_simulator,
  callback_url: "http://localhost:4000/api/callback",
  # Optional: Set the serviceCode with which the simulator will call your endpoint.
  # Defaults to: *123#
  service_code: "*456#"
```

Start your phoenix server with `mix phx.server`. Now you can visit [`localhost:5123`](http://localhost:5123) from your browser.

### Why doesn't the simulator run at `localhost:4000`?

We wanted to separate the `ExUssdSimulator` dependencies from your project dependencies as much as possible. Your project potentially runs a "headless" phoenix endpoint, that is without Phoenix Views or templates or Phoenix LiveView. That is, API endpoints only. 

The `ExUssdSimulator` however, depends on Phoenix LiveView, which also needs to be configured. We did not want you to configure LiveView only to use the simulator, which is why we start a separate endpoint for the simulator in the `:dev`-environment only.

## Development

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:5123`](http://localhost:5123) from your browser.

### Important

Please run `mix assets.compile` and push the changes in `priv/static/` before making any PRs.
This ensures that we always keep the production versions of `app.css` and `app.js` in the library and not the larger development versions.
