defmodule ExUssdSimulator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, [name: ExUssdSimulator.PubSub, adapter: Phoenix.PubSub.PG2]},
      # Start the Endpoint (http/https)
      ExUssdSimulator.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ExUssdSimulator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
